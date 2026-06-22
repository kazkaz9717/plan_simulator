document.addEventListener("DOMContentLoaded", () => {
    // ===== シミュレーション状態管理 =====
    function createEmptyState() {
        return {
            brandId: null,
            makerId: null,
            plans: [],
            subscriptions: [],
            options: [],
            deviceId: null,
            devicePrice: 0,
            deviceName: null,
            installment: '1',
            discounts: []
        };
    }

    let simulations = [createEmptyState()];
    let currentSim = 0;
    const MAX_SIM = 3;

    // ===== カテゴリタブ切り替え =====
    const tabBtns = document.querySelectorAll(".tab-btn");
    const tabContents = document.querySelectorAll(".tab-content");

    tabBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            tabBtns.forEach(b => b.classList.remove("active"));
            tabContents.forEach(c => c.classList.remove("active"));
            btn.classList.add("active");
            document.getElementById(`tab-${btn.dataset.tab}`).classList.add("active");
        });
    });

    // ===== 金額計算（内訳付き） =====
    function calcFromState(state) {
        // 永続的な月額（プラン + サブスク）
        let planFee = 0;
        state.plans.forEach(p => planFee += p.price);

        let subscriptionFee = 0;
        state.subscriptions.forEach(s => subscriptionFee += s.price);

        // オプション（分割は月額、一括は当日）
        let optionMonthly = 0;
        let optionToday = 0;
        const optionInstallments = []; // {monthly, until} 分割オプションの情報
        state.options.forEach(o => {
            if (o.installment === 1) {
                optionToday += o.price;
            } else {
                const monthly = Math.ceil(o.price / o.installment);
                optionMonthly += monthly;
                optionInstallments.push({ monthly, until: o.installment });
            }
        });

        // 機種（分割は月額、一括は当日）
        let deviceMonthly = 0;
        let deviceToday = 0;
        let deviceInstallment = null; // {monthly, until}
        if (state.deviceId) {
            const inst = parseInt(state.installment);
            if (inst === 1) {
                deviceToday += state.devicePrice;
            } else {
                const monthly = Math.ceil(state.devicePrice / inst);
                deviceMonthly += monthly;
                deviceInstallment = { monthly, until: inst };
            }
        }

        const totalDiscount = state.discounts.reduce((sum, d) => sum + d.amount, 0);
        const baseTotal = planFee + subscriptionFee + optionMonthly + deviceMonthly;
        const todayFee = optionToday + deviceToday;

        // 永続費用（分割が全て終わった後も残る月額）= プラン + サブスク
        const permanentMonthly = planFee + subscriptionFee;

        return {
            planFee, subscriptionFee, optionMonthly, deviceMonthly,
            totalDiscount, baseTotal, todayFee,
            discounts: state.discounts,
            permanentMonthly,        // プラン+サブスク（ずっと続く）
            deviceInstallment,       // 機種の分割情報 or null
            optionInstallments       // オプション分割の配列
        };
    }

    // 指定した月(targetMonth)における月額を計算する
    function monthlyFeeAt(targetMonth, r) {
        // プラン + サブスク（永続）
        let total = r.permanentMonthly;

        // 機種の分割（分割期間内なら加算）
        if (r.deviceInstallment && targetMonth <= r.deviceInstallment.until) {
            total += r.deviceInstallment.monthly;
        }

        // オプションの分割（それぞれ分割期間内なら加算）
        r.optionInstallments.forEach(o => {
            if (targetMonth <= o.until) {
                total += o.monthly;
            }
        });

        // 割引（永年 or まだ期間内なら適用）
        const activeDiscount = r.discounts
            .filter(d => d.duration === null || d.duration >= targetMonth)
            .reduce((sum, d) => sum + d.amount, 0);

        return Math.max(0, total - activeDiscount);
    }

    // 区切り月ごとに月額を段階表示する
    function buildMonthlyLines(r) {
        // お金が変わる「区切り月」を全て集める
        const breakpoints = new Set();

        // 割引の終了月
        r.discounts.forEach(d => {
            if (d.duration) breakpoints.add(d.duration);
        });
        // 機種の分割終了月
        if (r.deviceInstallment) breakpoints.add(r.deviceInstallment.until);
        // オプションの分割終了月
        r.optionInstallments.forEach(o => breakpoints.add(o.until));

        // 区切りがなければ1行だけ表示
        if (breakpoints.size === 0) {
            return `<div class="result-total">月額合計：¥${monthlyFeeAt(1, r).toLocaleString()}</div>`;
        }

        // 区切り月を昇順に並べる
        const sorted = [...breakpoints].sort((a, b) => a - b);

        let html = '';
        let prevMonth = 0;
        sorted.forEach(month => {
            // この区間の代表月（開始月）で月額を計算
            const fee = monthlyFeeAt(prevMonth + 1, r);
            html += `<div class="result-total">月額合計（${prevMonth + 1}〜${month}ヶ月目）：¥${fee.toLocaleString()}</div>`;
            prevMonth = month;
        });

        // 全ての分割・期間限定が終わった後（永続費用のみ）
        const finalFee = monthlyFeeAt(prevMonth + 1, r);
        html += `<div class="result-total">月額合計（${prevMonth + 1}ヶ月目以降）：¥${finalFee.toLocaleString()}</div>`;

        return html;
    }

    function buildResultCard(state, index) {
        const r = calcFromState(state);
        let html = `<div class="result-card ${index === currentSim ? 'result-active' : ''}" data-index="${index}">`;

        if (simulations.length > 1) {
            html += `<button type="button" class="card-delete-btn" data-delete="${index}">×</button>`;
        }

        html += `<h3>シミュレーション${index + 1}</h3>`;
        html += '<div class="result-breakdown">';

        if (r.planFee > 0) html += `<div>料金プラン：¥${r.planFee.toLocaleString()}</div>`;
        if (r.totalDiscount > 0) html += `<div>割引：△¥${r.totalDiscount.toLocaleString()}</div>`;
        if (r.subscriptionFee > 0) html += `<div>サブスク：¥${r.subscriptionFee.toLocaleString()}</div>`;
        if (r.deviceMonthly > 0) html += `<div>機種(月額)：¥${r.deviceMonthly.toLocaleString()}</div>`;
        if (r.optionMonthly > 0) html += `<div>オプション(月額)：¥${r.optionMonthly.toLocaleString()}</div>`;

        html += '</div>';
        html += buildMonthlyLines(r);
        html += `<div class="result-today">当日払う料金：¥${r.todayFee.toLocaleString()}</div>`;
        html += '</div>';
        return html;
    }

    function renderResults() {
        const area = document.getElementById("results-area");
        let html = simulations.map((sim, i) => buildResultCard(sim, i)).join('');

        const emptySlots = MAX_SIM - simulations.length;
        for (let i = 0; i < emptySlots; i++) {
            html += `
                <div class="add-card">
                    <button type="button" class="add-toggle">＋</button>
                    <div class="add-menu" style="display:none;">
                        <button type="button" class="add-empty-btn">空で追加</button>
                        <button type="button" class="add-copy-btn">コピーして追加</button>
                    </div>
                </div>
            `;
        }

        area.innerHTML = html;
        attachResultEvents();
        renderDetail();
    }

    // 選択中シミュレーションの詳細を表示
    function renderDetail() {
        const state = simulations[currentSim];
        const r = calcFromState(state);
        const area = document.getElementById("detail-area");

        let html = `<div class="detail-box">`;
        html += `<h2>シミュレーション${currentSim + 1} の詳細</h2>`;

        // 料金プラン
        if (state.plans.length > 0) {
            html += `<h3>料金プラン</h3><ul>`;
            state.plans.forEach(p => {
                html += `<li>${p.name}　¥${p.price.toLocaleString()}/月</li>`;
            });
            html += `</ul>`;
        }

        // 割引
        if (state.discounts.length > 0) {
            html += `<h3>割引</h3><ul>`;
            state.discounts.forEach(d => {
                const period = d.duration ? `（${d.duration}ヶ月間）` : '（永年）';
                html += `<li>${d.name}　-¥${d.amount.toLocaleString()}/月 ${period}</li>`;
            });
            html += `</ul>`;
        }

        // サブスク
        if (state.subscriptions.length > 0) {
            html += `<h3>サブスクリプション</h3><ul>`;
            state.subscriptions.forEach(s => {
                html += `<li>${s.name}　¥${s.price.toLocaleString()}/月</li>`;
            });
            html += `</ul>`;
        }

        // 機種
        if (state.deviceId) {
            const inst = parseInt(state.installment);
            const payment = inst === 1
                ? '一括'
                : `${inst}回払い → ¥${Math.ceil(state.devicePrice / inst).toLocaleString()}/月`;
            html += `<h3>機種</h3><ul>`;
            html += `<li>${state.deviceName}　¥${state.devicePrice.toLocaleString()}（${payment}）</li>`;
            html += `</ul>`;
        }

        // オプション
        if (state.options.length > 0) {
            html += `<h3>オプション</h3><ul>`;
            state.options.forEach(o => {
                const payment = o.installment === 1
                    ? '一括'
                    : `${o.installment}回払い → ¥${Math.ceil(o.price / o.installment).toLocaleString()}/月`;
                html += `<li>${o.name}　¥${o.price.toLocaleString()}（${payment}）</li>`;
            });
            html += `</ul>`;
        }

        // 何も選択されていない場合
        if (state.plans.length === 0 && state.discounts.length === 0 &&
            state.subscriptions.length === 0 && state.options.length === 0 && !state.deviceId) {
            html += `<p>項目が選択されていません</p>`;
        }

        // 合計
        html += `<div class="detail-total">`;
        html += buildMonthlyLines(r);
        html += `<div class="result-today">当日払う料金：¥${r.todayFee.toLocaleString()}</div>`;
        html += `</div>`;

        html += `<button type="button" id="print-detail" class="print-btn">この内容を印刷する</button>`;
        html += `</div>`;

        area.innerHTML = html;
    }

    function attachResultEvents() {
        document.querySelectorAll('.result-card').forEach(card => {
            card.addEventListener("click", (e) => {
                if (e.target.classList.contains('card-delete-btn')) return;
                currentSim = parseInt(card.dataset.index);
                restoreUI();
            });
        });

        document.querySelectorAll('.card-delete-btn').forEach(btn => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                const deleteIdx = parseInt(btn.dataset.delete);
                simulations.splice(deleteIdx, 1);
                if (currentSim >= simulations.length) {
                    currentSim = simulations.length - 1;
                } else if (currentSim > deleteIdx) {
                    currentSim--;
                }
                restoreUI();
            });
        });

        document.querySelectorAll('.add-toggle').forEach(toggle => {
            toggle.addEventListener("click", () => {
                const menu = toggle.nextElementSibling;
                menu.style.display = menu.style.display === 'none' ? 'flex' : 'none';
            });
        });

        document.querySelectorAll('.add-empty-btn').forEach(btn => {
            btn.addEventListener("click", () => {
                if (simulations.length >= MAX_SIM) return;
                simulations.push(createEmptyState());
                currentSim = simulations.length - 1;
                restoreUI();
            });
        });

        document.querySelectorAll('.add-copy-btn').forEach(btn => {
            btn.addEventListener("click", () => {
                if (simulations.length >= MAX_SIM) return;
                const copy = JSON.parse(JSON.stringify(simulations[currentSim]));
                simulations.push(copy);
                currentSim = simulations.length - 1;
                restoreUI();
            });
        });
    }

    // ===== 選択を状態に保存 =====
    document.addEventListener("change", (e) => {
        const state = simulations[currentSim];
        const t = e.target;

        if (t.classList.contains("plan-radio")) {
            state.plans = Array.from(document.querySelectorAll('.plan-radio:checked'))
                .map(el => ({ id: parseInt(el.value), price: parseInt(el.dataset.price), name: el.dataset.name }));
        }
        if (t.name === "subscriptions[]") {
            state.subscriptions = Array.from(document.querySelectorAll('input[name="subscriptions[]"]:checked'))
                .map(el => ({ id: parseInt(el.value), price: parseInt(el.dataset.price), name: el.dataset.name }));
        }
        if (t.name === "options[]" || (t.classList.contains("installment-select") && t.closest('#tab-option'))) {
            state.options = Array.from(document.querySelectorAll('input[name="options[]"]:checked'))
                .map(el => {
                    const inst = parseInt(el.closest('.plan-card').querySelector('.installment-select').value);
                    return { id: parseInt(el.value), price: parseInt(el.dataset.price), installment: inst, name: el.dataset.name };
                });
        }
        if (t.name === "device") {
            state.deviceId = parseInt(t.value);
            state.devicePrice = parseInt(t.dataset.price);
            state.deviceName = t.dataset.name;
            state.installment = t.closest('.plan-card').querySelector('.installment-select').value;
        }
        if (t.classList.contains("installment-select") && t.closest('#tab-device')) {
            const deviceRadio = t.closest('.plan-card').querySelector('input[name="device"]');
            if (deviceRadio && deviceRadio.checked) {
                state.installment = t.value;
            }
        }
        if (t.name === "discounts[]" || t.classList.contains("discount-radio")) {
            state.discounts = Array.from(document.querySelectorAll('input[name="discounts[]"]:checked, .discount-radio:checked'))
                .map(el => ({
                    id: parseInt(el.value),
                    amount: parseInt(el.dataset.price),
                    duration: el.dataset.duration ? parseInt(el.dataset.duration) : null,
                    name: el.dataset.name
                }));
        }

        renderResults();
    });

    // ===== クリアボタン（機種・割引）を全体監視で処理 =====
    document.addEventListener("click", (e) => {
        const state = simulations[currentSim];

        if (e.target.id === "clear-device") {
            document.querySelectorAll('input[name="device"]').forEach(el => el.checked = false);
            state.deviceId = null;
            state.devicePrice = 0;
            state.installment = '1';
            renderResults();
        }

        if (e.target.id === "clear-discount") {
            document.querySelectorAll('input[name="discounts[]"], .discount-radio').forEach(el => el.checked = false);
            state.discounts = [];
            renderResults();
        }

        if (e.target.id === "print-detail") {
            window.print();
        }
    });

    // ===== ブランド選択 =====
    document.querySelectorAll('input[name="plan_brand"]').forEach(el => {
        el.addEventListener("change", () => {
            const brandId = parseInt(el.value);
            const state = simulations[currentSim];
            state.brandId = brandId;
            state.plans = [];
            state.discounts = [];
            renderPlans(brandId);
            renderDiscounts(brandId);
            renderResults();
        });
    });

    function renderPlans(brandId) {
        const brand = plansByBrand.find(b => b.id === brandId);
        const plansArea = document.getElementById("plans-area");
        if (!brand) { plansArea.innerHTML = ''; return; }

        // group_nameごとにプランをまとめる
        const grouped = {};
        const standalone = [];
        brand.plans.forEach(p => {
            if (p.group_name) {
                if (!grouped[p.group_name]) grouped[p.group_name] = [];
                grouped[p.group_name].push(p);
            } else {
                standalone.push(p);
            }
        });

        let html = '';

        // グループありのプラン（グループ内はラジオで1つだけ選択）
        Object.keys(grouped).forEach(groupName => {
            html += `<h3>${groupName}</h3>`;
            html += grouped[groupName].map(plan => `
                <div class="plan-card">
                    <label>
                        <input type="radio" name="plan_group_${groupName}" value="${plan.id}"
                            class="plan-radio" data-price="${plan.monthly_fee}" data-name="${plan.name}">
                        ${plan.name} ¥${plan.monthly_fee.toLocaleString()}/月
                    </label>
                </div>
            `).join('');
        });

        // グループなしのプラン
        if (standalone.length > 0) {
            html += '<h3>その他のプラン</h3>';
            html += standalone.map(plan => `
                <div class="plan-card">
                    <label>
                        <input type="radio" name="plan_group_none" value="${plan.id}"
                            class="plan-radio" data-price="${plan.monthly_fee}" data-name="${plan.name}">
                        ${plan.name} ¥${plan.monthly_fee.toLocaleString()}/月
                    </label>
                </div>
            `).join('');
        }

        plansArea.innerHTML = html;
    }

    function renderDiscounts(brandId) {
        const discountsArea = document.getElementById("discounts-area");
        const brandDiscounts = discounts.filter(d => d.plan_brand_ids.includes(brandId));

        if (brandDiscounts.length === 0) {
            discountsArea.innerHTML = '<p>このブランドで使える割引はありません</p>';
            return;
        }

        const grouped = {};
        const standalone = [];
        brandDiscounts.forEach(d => {
            if (d.group_name) {
                if (!grouped[d.group_name]) grouped[d.group_name] = [];
                grouped[d.group_name].push(d);
            } else {
                standalone.push(d);
            }
        });

        let html = '';
        Object.keys(grouped).forEach(groupName => {
            html += `<h3>${groupName}（いずれか1つ）</h3>`;
            html += grouped[groupName].map(discount => `
                <div class="plan-card">
                    <label>
                        <input type="radio" name="discount_group_${groupName}" value="${discount.id}"
                            class="discount-radio"
                            data-price="${discount.amount}"
                            data-duration="${discount.duration_months || ''}"
                            data-name="${discount.name}">
                        ${discount.name} -¥${discount.amount.toLocaleString()}/月
                        ${discount.duration_months ? `（${discount.duration_months}ヶ月間）` : '（永年）'}
                    </label>
                </div>
            `).join('');
        });

        if (standalone.length > 0) {
            html += '<h3>その他の割引</h3>';
            html += standalone.map(discount => `
                <div class="plan-card">
                    <label>
                        <input type="checkbox" name="discounts[]" value="${discount.id}"
                            data-price="${discount.amount}"
                            data-duration="${discount.duration_months || ''}"
                            data-name="${discount.name}">
                        ${discount.name} -¥${discount.amount.toLocaleString()}/月
                        ${discount.duration_months ? `（${discount.duration_months}ヶ月間）` : '（永年）'}
                    </label>
                </div>
            `).join('');
        }

        discountsArea.innerHTML = html;
    }

    // ===== メーカー選択 =====
    document.querySelectorAll('input[name="device_maker"]').forEach(el => {
        el.addEventListener("change", () => {
            const makerId = parseInt(el.value);
            simulations[currentSim].makerId = makerId;
            renderDevices(makerId);
            renderResults();
        });
    });

    function renderDevices(makerId) {
        const maker = devicesByMaker.find(m => m.id === makerId);
        const devicesArea = document.getElementById("devices-area");
        const state = simulations[currentSim];

        if (!maker || maker.devices.length === 0) {
            devicesArea.innerHTML = '<p>このメーカーの機種はありません</p>';
            return;
        }

        // group_nameごとにグループ分け（グループなしは standalone へ）
        const grouped = {};
        const standalone = [];
        maker.devices.forEach(device => {
            if (device.group_name) {
                if (!grouped[device.group_name]) grouped[device.group_name] = [];
                grouped[device.group_name].push(device);
            } else {
                standalone.push(device);
            }
        });

        // 1台分のカードHTMLを作る共通関数
        const deviceCard = (device) => `
            <div class="plan-card">
                <label>
                    <input type="radio" name="device" value="${device.id}" data-price="${device.price}"
                        data-name="${device.name}"
                        ${state.deviceId === device.id ? 'checked' : ''}>
                    ${device.name}（${device.maker_name}） ¥${device.price.toLocaleString()}
                </label>
                <div>
                    分割回数：
                    <select class="installment-select" data-price="${device.price}">
                        <option value="1" ${state.installment === '1' ? 'selected' : ''}>一括</option>
                        <option value="12" ${state.installment === '12' ? 'selected' : ''}>12回</option>
                        <option value="24" ${state.installment === '24' ? 'selected' : ''}>24回</option>
                        <option value="36" ${state.installment === '36' ? 'selected' : ''}>36回</option>
                        <option value="48" ${state.installment === '48' ? 'selected' : ''}>48回</option>
                    </select>
                </div>
            </div>
        `;

        let html = '';

        // グループありを見出し付きで表示
        Object.keys(grouped).forEach(groupName => {
            html += `<h3>${groupName}</h3>`;
            html += grouped[groupName].map(deviceCard).join('');
        });

        // グループなしを最後に表示
        if (standalone.length > 0) {
            html += '<h3>その他</h3>';
            html += standalone.map(deviceCard).join('');
        }

        devicesArea.innerHTML = html;
    }

    // ===== UI復元 =====
    function restoreUI() {
        const state = simulations[currentSim];

        document.querySelectorAll('input[type="checkbox"], input[type="radio"]').forEach(el => el.checked = false);

        if (state.brandId) {
            const brandRadio = document.querySelector(`input[name="plan_brand"][value="${state.brandId}"]`);
            if (brandRadio) brandRadio.checked = true;
            renderPlans(state.brandId);
            renderDiscounts(state.brandId);

            state.plans.forEach(p => {
                const el = document.querySelector(`.plan-radio[value="${p.id}"]`);
                if (el) el.checked = true;
            });

            state.discounts.forEach(d => {
                const el = document.querySelector(`input[name="discounts[]"][value="${d.id}"], .discount-radio[value="${d.id}"]`);
                if (el) el.checked = true;
            });
        } else {
            document.getElementById("plans-area").innerHTML = '<p>ブランドを選択してください</p>';
            document.getElementById("discounts-area").innerHTML = '<p>先に料金プランタブでブランドを選択してください</p>';
        }

        state.subscriptions.forEach(s => {
            const el = document.querySelector(`input[name="subscriptions[]"][value="${s.id}"]`);
            if (el) el.checked = true;
        });

        state.options.forEach(o => {
            const el = document.querySelector(`input[name="options[]"][value="${o.id}"]`);
            if (el) {
                el.checked = true;
                const select = el.closest('.plan-card').querySelector('.installment-select');
                if (select) select.value = o.installment;
            }
        });

        if (state.makerId) {
            const makerRadio = document.querySelector(`input[name="device_maker"][value="${state.makerId}"]`);
            if (makerRadio) makerRadio.checked = true;
            renderDevices(state.makerId);
        } else {
            document.getElementById("devices-area").innerHTML = '<p>メーカーを選択してください</p>';
        }

        renderResults();
    }

    // ===== 初期化 =====
    restoreUI();
});

// ============================================================
// 削除確認モーダルの制御
// 削除フォームの送信を一度止めてモーダルを表示し、
// 「削除する」で本来の送信を実行する。
// ============================================================
document.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("delete-modal");
    if (!modal) return; // モーダルが無いページ（管理画面以外）では何もしない

    const message = document.getElementById("delete-modal-message");
    const cancelBtn = document.getElementById("delete-modal-cancel");
    const confirmBtn = document.getElementById("delete-modal-confirm");

    let targetForm = null; // 削除対象のフォームを覚えておく変数

    // 削除フォームの送信を横取り
    document.addEventListener("submit", (e) => {
        const form = e.target;
        // 目印クラスが付いた削除フォームだけ対象
        if (!form.classList.contains("js-delete-form")) return;

        e.preventDefault();    // いったん送信を止める
        targetForm = form;     // このフォームを覚えておく

        // data-message があればその文言を、無ければデフォルトを表示
        message.textContent = form.dataset.message || "本当に削除しますか？";

        modal.classList.add("is-open"); // モーダルを開く
    });

    // 「削除する」→ 覚えておいたフォームを本当に送信
    confirmBtn.addEventListener("click", () => {
        if (targetForm) {
            targetForm.classList.remove("js-delete-form"); // 横取り対象から外す
            targetForm.submit();                            // 実際に送信
        }
    });

    // 「キャンセル」→ モーダルを閉じる
    cancelBtn.addEventListener("click", () => {
        modal.classList.remove("is-open");
        targetForm = null;
    });

    // 背景（暗い部分）クリックでも閉じる
    modal.addEventListener("click", (e) => {
        if (e.target === modal) {
            modal.classList.remove("is-open");
            targetForm = null;
        }
    });
});