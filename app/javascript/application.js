document.addEventListener("DOMContentLoaded", () => {
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

    // 合計金額計算
    function calcTotal() {
        let total = 0;
        let todayFee = 0;

        // データプラン
        const dataPlan = document.querySelector('input[name="data_plan"]:checked');
        if (dataPlan) total += parseInt(dataPlan.dataset.price);

        // 音声通話プラン
        const voicePlan = document.querySelector('input[name="voice_plan"]:checked');
        if (voicePlan) total += parseInt(voicePlan.dataset.price);

        // キッズケータイプラン
        const kidsPlan = document.querySelector('input[name="kids_plan"]:checked');
        if (kidsPlan) total += parseInt(kidsPlan.dataset.price);

        // サブスクリプション
        document.querySelectorAll('input[name="subscriptions[]"]:checked').forEach(el => {
            total += parseInt(el.dataset.price);
        });

        // オプション（分割・一括計算）
        document.querySelectorAll('input[name="options[]"]').forEach(el => {
            if (el.checked) {
                const price = parseInt(el.dataset.price);
                const installment = parseInt(el.closest('.plan-card').querySelector('.installment-select').value);
                if (installment === 1) {
                    todayFee += price;
                } else {
                    total += Math.ceil(price / installment);
                }
            }
        });

        // 機種（分割・一括計算）
        const device = document.querySelector('input[name="device"]:checked');
        if (device) {
            const price = parseInt(device.dataset.price);
            const installment = parseInt(device.closest('.plan-card').querySelector('.installment-select').value);
            if (installment === 1) {
                todayFee += price;
            } else {
                total += Math.ceil(price / installment);
            }
        }

        document.getElementById("total-fee").textContent = total.toLocaleString();
        document.getElementById("today-fee").textContent = todayFee.toLocaleString();
    }

    // イベントリスナー
    document.addEventListener("change", calcTotal);

    // 機種クリアボタン
    const clearDeviceBtn = document.getElementById("clear-device");
    if (clearDeviceBtn) {
        clearDeviceBtn.addEventListener("click", () => {
            document.querySelectorAll('input[name="device"]').forEach(el => {
                el.checked = false;
            });
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

            calcTotal();
        });
    });
});