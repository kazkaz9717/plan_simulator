document.addEventListener("DOMContentLoaded", () => {
    // ===== シミュレーション状態管理 =====
    function createEmptyState() {
        return {
            brandId: null,
            makerId: null,
            dataPlan: null,
            voicePlan: null,
            kidsPlan: null,
            subscriptions: [],
            options: [],
            deviceId: null,
            devicePrice: 0,
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
        let planFee = 0;
        if (state.dataPlan) planFee += state.dataPlan.price;
        if (state.voicePlan) planFee += state.voicePlan.price;
        if (state.kidsPlan) planFee += state.kidsPlan.price;

        let subscriptionFee = 0;
        state.subscriptions.forEach(s => subscriptionFee += s.price);

        let optionMonthly = 0;
        let optionToday = 0;
        state.options.forEach(o => {
            if (o.installment === 1) {
                optionToday += o.price;
            } else {
                optionMonthly += Math.ceil(o.price / o.installment);
            }
        });

        let deviceMonthly = 0;
        let deviceToday = 0;
        if (state.deviceId) {
            const inst = parseInt(state.installment);
            if (inst === 1) {
                deviceToday += state.devicePrice;
            } else {
                deviceMonthly += Math.ceil(state.devicePrice / inst);
            }
        }

        const totalDiscount = state.discounts.reduce((sum, d) => sum + d.amount, 0);
        const baseTotal = planFee + subscriptionFee + optionMonthly + deviceMonthly;
        const todayFee = optionToday + deviceToday;

        return {
            planFee, subscriptionFee, optionMonthly, deviceMonthly,
            totalDiscount, baseTotal, todayFee, discounts: state.discounts
        };
    }

    function buildMonthlyLines(baseTotal, discounts) {
        const durations = [...new Set(discounts.filter(d => d.duration).map(d => d.duration))].sort((a, b) => a - b);

        if (durations.length === 0) {
            const permanentDiscount = discounts.reduce((sum, d) => sum + d.amount, 0);
            return `<div class="result-total">月額合計：¥${Math.max(0, baseTotal - permanentDiscount).toLocaleString()}</div>`;
        }

        let html = '';
        let prevMonth = 0;
        durations.forEach(duration => {
            const activeDiscount = discounts
                .filter(d => d.duration === null || d.duration >= duration)
                .reduce((sum, d) => sum + d.amount, 0);
            html += `<div class="result-total">月額合計（${prevMonth + 1}〜${duration}ヶ月目）：¥${Math.max(0, baseTotal - activeDiscount).toLocaleString()}</div>`;
            prevMonth = duration;
        });
        const permanentDiscount = discounts.filter(d => d.duration === null).reduce((sum, d) => sum + d.amount, 0);
        html += `<div class="result-total">月額合計（${prevMonth + 1}ヶ月目以降）：¥${Math.max(0, baseTotal - permanentDiscount).toLocaleString()}</div>`;
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
        if (r.optionMonthly > 0) html += `<div>オプション(月額)：¥${r.optionMonthly.toLocaleString()}</div>`;
        if (r.deviceMonthly > 0) html += `<div>機種(月額)：¥${r.deviceMonthly.toLocaleString()}</div>`;

        html += '</div>';
        html += buildMonthlyLines(r.baseTotal, r.discounts);
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

        if (t.name === "data_plan") {
            state.dataPlan = { id: parseInt(t.value), price: parseInt(t.dataset.price) };
        }
        if (t.name === "voice_plan") {
            state.voicePlan = { id: parseInt(t.value), price: parseInt(t.dataset.price) };
        }
        if (t.name === "kids_plan") {
            state.kidsPlan = { id: parseInt(t.value), price: parseInt(t.dataset.price) };
        }
        if (t.name === "subscriptions[]") {
            state.subscriptions = Array.from(document.querySelectorAll('input[name="subscriptions[]"]:checked'))
                .map(el => ({ id: parseInt(el.value), price: parseInt(el.dataset.price) }));
        }
        if (t.name === "options[]" || (t.classList.contains("installment-select") && t.closest('#tab-option'))) {
            state.options = Array.from(document.querySelectorAll('input[name="options[]"]:checked'))
                .map(el => {
                    const inst = parseInt(el.closest('.plan-card').querySelector('.installment-select').value);
                    return { id: parseInt(el.value), price: parseInt(el.dataset.price), installment: inst };
                });
        }
        if (t.name === "device") {
            state.deviceId = parseInt(t.value);
            state.devicePrice = parseInt(t.dataset.price);
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
                    duration: el.dataset.duration ? parseInt(el.dataset.duration) : null
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
    });

    // ===== ブランド選択 =====
    document.querySelectorAll('input[name="plan_brand"]').forEach(el => {
        el.addEventListener("change", () => {
            const brandId = parseInt(el.value);
            const state = simulations[currentSim];
            state.brandId = brandId;
            state.dataPlan = null;
            state.voicePlan = null;
            state.kidsPlan = null;
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

        const categories = [
            { name: 'データプラン', inputName: 'data_plan' },
            { name: '音声通話プラン', inputName: 'voice_plan' },
            { name: 'キッズケータイプラン', inputName: 'kids_plan' }
        ];

        plansArea.innerHTML = categories.map(category => {
            const plans = brand.plans.filter(p => p.category === category.name);
            if (plans.length === 0) return '';
            return `
                <h3>${category.name}</h3>
                ${plans.map(plan => `
                    <div class="plan-card">
                        <label>
                            <input type="radio" name="${category.inputName}" value="${plan.id}" data-price="${plan.monthly_fee}">
                            ${plan.name} ¥${plan.monthly_fee.toLocaleString()}/月
                        </label>
                    </div>
                `).join('')}
            `;
        }).join('');
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
                            data-duration="${discount.duration_months || ''}">
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
                            data-duration="${discount.duration_months || ''}">
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

        devicesArea.innerHTML = maker.devices.map(device => `
            <div class="plan-card">
                <label>
                    <input type="radio" name="device" value="${device.id}" data-price="${device.price}"
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
        `).join('');
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

            if (state.dataPlan) {
                const r = document.querySelector(`input[name="data_plan"][value="${state.dataPlan.id}"]`);
                if (r) r.checked = true;
            }
            if (state.voicePlan) {
                const r = document.querySelector(`input[name="voice_plan"][value="${state.voicePlan.id}"]`);
                if (r) r.checked = true;
            }
            if (state.kidsPlan) {
                const r = document.querySelector(`input[name="kids_plan"][value="${state.kidsPlan.id}"]`);
                if (r) r.checked = true;
            }
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