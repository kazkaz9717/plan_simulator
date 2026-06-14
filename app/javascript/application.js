document.addEventListener("DOMContentLoaded", () => {
    // ページ読み込み時に選択状態をリセット
    document.querySelectorAll('input[type="checkbox"], input[type="radio"]').forEach(el => {
        el.checked = false;
    });
    document.querySelectorAll('.installment-select').forEach(el => {
        el.value = '1';
    });

    // タブ切り替え
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

    function calcTotal() {
        let baseTotal = 0;
        let todayFee = 0;

        // データプラン
        const dataPlan = document.querySelector('input[name="data_plan"]:checked');
        if (dataPlan) baseTotal += parseInt(dataPlan.dataset.price);

        // 音声通話プラン
        const voicePlan = document.querySelector('input[name="voice_plan"]:checked');
        if (voicePlan) baseTotal += parseInt(voicePlan.dataset.price);

        // キッズケータイプラン
        const kidsPlan = document.querySelector('input[name="kids_plan"]:checked');
        if (kidsPlan) baseTotal += parseInt(kidsPlan.dataset.price);

        // サブスクリプション
        document.querySelectorAll('input[name="subscriptions[]"]:checked').forEach(el => {
            baseTotal += parseInt(el.dataset.price);
        });

        // オプション（分割・一括計算）
        document.querySelectorAll('input[name="options[]"]').forEach(el => {
            if (el.checked) {
                const price = parseInt(el.dataset.price);
                const installment = parseInt(el.closest('.plan-card').querySelector('.installment-select').value);
                if (installment === 1) {
                    todayFee += price;
                } else {
                    baseTotal += Math.ceil(price / installment);
                }
            }
        });

        // 機種（保持した変数で計算）
        if (selectedDeviceId) {
            const installment = parseInt(selectedInstallment);
            if (installment === 1) {
                todayFee += selectedDevicePrice;
            } else {
                baseTotal += Math.ceil(selectedDevicePrice / installment);
            }
        }

        // 割引（期間別に集計）
        const selectedDiscounts = [];
        document.querySelectorAll('input[name="discounts[]"]:checked, .discount-radio:checked').forEach(el => {
            selectedDiscounts.push({
                amount: parseInt(el.dataset.price),
                duration: el.dataset.duration ? parseInt(el.dataset.duration) : null
            });
        });

        // 期間の区切りを作る
        const durations = [...new Set(selectedDiscounts.filter(d => d.duration).map(d => d.duration))].sort((a, b) => a - b);

        const totalFeesArea = document.getElementById("total-fees");

        if (durations.length === 0) {
            // 期間限定割引なし：1行表示
            const permanentDiscount = selectedDiscounts.reduce((sum, d) => sum + d.amount, 0);  // ← 修正①
            totalFeesArea.innerHTML = `<h2>月額合計：¥${Math.max(0, baseTotal - permanentDiscount).toLocaleString()}</h2>`;
        } else {
            // 期間限定割引あり：段階表示
            let html = '';
            let prevMonth = 0;

            durations.forEach(duration => {
                const activeDiscount = selectedDiscounts  // ← 修正②
                    .filter(d => d.duration === null || d.duration >= duration)
                    .reduce((sum, d) => sum + d.amount, 0);
                html += `<h2>月額合計（${prevMonth + 1}〜${duration}ヶ月目）：¥${Math.max(0, baseTotal - activeDiscount).toLocaleString()}</h2>`;
                prevMonth = duration;
            });

            // 期間終了後
            const permanentDiscount = selectedDiscounts.filter(d => d.duration === null).reduce((sum, d) => sum + d.amount, 0);  // ← 修正③
            html += `<h2>月額合計（${prevMonth + 1}ヶ月目以降）：¥${Math.max(0, baseTotal - permanentDiscount).toLocaleString()}</h2>`;

            totalFeesArea.innerHTML = html;
        }

        document.getElementById("today-fee").textContent = todayFee.toLocaleString();
    }

    // イベントリスナー
    document.addEventListener("change", calcTotal);

    // 選択中の機種を保持する変数
    let selectedDeviceId = null;
    let selectedDevicePrice = 0;
    let selectedInstallment = '1';

    // 機種クリアボタン
    const clearDeviceBtn = document.getElementById("clear-device");
    if (clearDeviceBtn) {
        clearDeviceBtn.addEventListener("click", () => {
            document.querySelectorAll('input[name="device"]').forEach(el => {
                el.checked = false;
            });
            selectedDeviceId = null;
            selectedDevicePrice = 0;
            selectedInstallment = '1';
            calcTotal();
        });
    }

    // ブランド選択時にプランを表示
    document.querySelectorAll('input[name="plan_brand"]').forEach(el => {
        el.addEventListener("change", () => {
            const brandId = parseInt(el.value);
            const brand = plansByBrand.find(b => b.id === brandId);
            const plansArea = document.getElementById("plans-area");

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

            // 選択したブランドに対応する割引を表示
            const discountsArea = document.getElementById("discounts-area");
            const brandDiscounts = discounts.filter(d => d.plan_brand_ids.includes(brandId));

            if (brandDiscounts.length === 0) {
                discountsArea.innerHTML = '<p>このブランドで使える割引はありません</p>';
            } else {
                // グループごとに分類
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

                // グループ割引（ラジオボタン）
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

                // 単独割引（チェックボックス）
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
            calcTotal();
        });
    });

    // メーカー選択時に機種を表示
    document.querySelectorAll('input[name="device_maker"]').forEach(el => {
        el.addEventListener("change", () => {
            const makerId = parseInt(el.value);
            const maker = devicesByMaker.find(m => m.id === makerId);
            const devicesArea = document.getElementById("devices-area");

            if (!maker || maker.devices.length === 0) {
                devicesArea.innerHTML = '<p>このメーカーの機種はありません</p>';
            } else {
                devicesArea.innerHTML = maker.devices.map(device => `
                    <div class="plan-card">
                        <label>
                            <input type="radio" name="device" value="${device.id}" data-price="${device.price}"
                                ${selectedDeviceId === device.id ? 'checked' : ''}>
                            ${device.name}（${device.maker_name}） ¥${device.price.toLocaleString()}
                        </label>
                        <div>
                            分割回数：
                            <select class="installment-select" data-price="${device.price}">
                                <option value="1" ${selectedInstallment === '1' ? 'selected' : ''}>一括</option>
                                <option value="12" ${selectedInstallment === '12' ? 'selected' : ''}>12回</option>
                                <option value="24" ${selectedInstallment === '24' ? 'selected' : ''}>24回</option>
                                <option value="36" ${selectedInstallment === '36' ? 'selected' : ''}>36回</option>
                                <option value="48" ${selectedInstallment === '48' ? 'selected' : ''}>48回</option>
                            </select>
                        </div>
                    </div>
                `).join('');
            }
            calcTotal();
        });
    });

    // 機種選択・分割回数の変更を記憶
    document.addEventListener("change", (e) => {
        if (e.target.name === "device") {
            selectedDeviceId = parseInt(e.target.value);
            selectedDevicePrice = parseInt(e.target.dataset.price);
            const select = e.target.closest('.plan-card').querySelector('.installment-select');
            selectedInstallment = select.value;
            calcTotal();
        }
        if (e.target.classList.contains("installment-select")) {
            const deviceRadio = e.target.closest('.plan-card').querySelector('input[name="device"]');
            if (deviceRadio && deviceRadio.checked) {
                selectedInstallment = e.target.value;
                calcTotal();
            }
        }
    });

});