# ============================================================
# サンプルデータ投入用 seeds.rb
# 実在企業名を避けた汎用的な通信プランのデモデータ。
# 多対多（プラン⇔ブランド、割引⇔ブランド）が活きる構成。
# ============================================================
# 何度実行しても重複しないよう find_or_create_by を使用。
# ※プラン・割引は「ブランド必須」バリデーションがあるため、
#   作成と同時に plan_brands を渡している。

# ------------------------------------------------------------
# 管理者（ゲストログイン用）
# ------------------------------------------------------------
User.find_or_create_by!(name: 'guest') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :admin
end

# 追加の管理者（店長など、店舗を管理する役割を想定）
User.find_or_create_by!(name: '店長 田中') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :admin
end

# 一般ユーザー（店舗スタッフを想定）
['スタッフ 佐藤', 'スタッフ 鈴木', 'スタッフ 高橋'].each do |staff_name|
  User.find_or_create_by!(name: staff_name) do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.role = :general
  end
end

# ------------------------------------------------------------
# ブランド
# ------------------------------------------------------------
brand_max    = PlanBrand.find_or_create_by!(name: 'スマホMAX')
brand_mini   = PlanBrand.find_or_create_by!(name: 'スマホmini')
brand_simple = PlanBrand.find_or_create_by!(name: 'シンプルプラン')
brand_kids   = PlanBrand.find_or_create_by!(name: 'キッズプラン')

# ------------------------------------------------------------
# プラン（group_name でデータ容量帯をグループ化）
# ブランド必須のため、作成時に plan_brands を渡す。
# ------------------------------------------------------------
# スマホMAX：大容量帯
Plan.find_or_create_by!(name: 'MAX 無制限') do |p|
  p.monthly_fee = 7315
  p.group_name = 'データ容量'
  p.plan_brands = [brand_max]
end
Plan.find_or_create_by!(name: 'MAX 〜3GB') do |p|
  p.monthly_fee = 5665
  p.group_name = 'データ容量'
  p.plan_brands = [brand_max]
end
Plan.find_or_create_by!(name: 'MAX 〜1GB') do |p|
  p.monthly_fee = 4565
  p.group_name = 'データ容量'
  p.plan_brands = [brand_max]
end

# スマホmini：段階制
Plan.find_or_create_by!(name: 'mini 〜5GB') do |p|
  p.monthly_fee = 3278
  p.group_name = 'データ容量'
  p.plan_brands = [brand_mini]
end
Plan.find_or_create_by!(name: 'mini 〜1GB') do |p|
  p.monthly_fee = 2178
  p.group_name = 'データ容量'
  p.plan_brands = [brand_mini]
end

# シンプルプラン（ワンプラン）
Plan.find_or_create_by!(name: 'シンプル 20GB') do |p|
  p.monthly_fee = 2970
  p.group_name = nil
  p.plan_brands = [brand_simple]
end

# キッズプラン
Plan.find_or_create_by!(name: 'キッズケータイプラン') do |p|
  p.monthly_fee = 550
  p.group_name = nil
  p.plan_brands = [brand_kids]
end

# 音声プラン
Plan.find_or_create_by!(name: 'かけ放題オプション') do |p|
  p.monthly_fee = 1980
  p.group_name = '通話オプション'
  p.plan_brands = [brand_max, brand_mini]
end
Plan.find_or_create_by!(name: '5分かけ放題') do |p|
  p.monthly_fee = 880
  p.group_name = '通話オプション'
  p.plan_brands = [brand_max, brand_mini]
end
Plan.find_or_create_by!(name: 'かけ放題オプション') do |p|
  p.monthly_fee = 1100
  p.group_name = '通話オプション'
  p.plan_brands = [brand_simple]
end

# ------------------------------------------------------------
# 割引（group_name で排他グループ。duration_months=nilは永年）
# 割引もブランド必須のため、作成時に plan_brands を渡す。
# ------------------------------------------------------------

# インターネットセット割（永年）：MAX/mini で共有
Discount.find_or_create_by!(name: '光セット割') do |d|
  d.amount = 1100
  d.duration_months = nil
  d.group_name = 'インターネットセット割'
  d.plan_brands = [brand_max, brand_mini]
end
Discount.find_or_create_by!(name: 'ホームルーターセット割') do |d|
  d.amount = 1100
  d.duration_months = nil
  d.group_name = 'インターネットセット割'
  d.plan_brands = [brand_max, brand_mini]
end

# 家族割（永年）：MAX/mini で共有
Discount.find_or_create_by!(name: '家族割（3回線以上）') do |d|
  d.amount = 1100
  d.duration_months = nil
  d.group_name = '家族割'
  d.plan_brands = [brand_max, brand_mini]
end
Discount.find_or_create_by!(name: '家族割（2回線以上）') do |d|
  d.amount = 550
  d.duration_months = nil
  d.group_name = '家族割'
  d.plan_brands = [brand_max, brand_mini]
end

# クレカ支払い割（永年）：MAX/mini/シンプルで共有
Discount.find_or_create_by!(name: 'クレカ支払い割') do |d|
  d.amount = 187
  d.duration_months = nil
  d.group_name = 'クレカ支払い割'
  d.plan_brands = [brand_max, brand_mini, brand_simple]
end

# のりかえキャンペーン割（6ヶ月間）：MAX限定
Discount.find_or_create_by!(name: 'のりかえキャンペーン割') do |d|
  d.amount = 1100
  d.duration_months = 6
  d.group_name = ''
  d.plan_brands = [brand_max]
end

# ------------------------------------------------------------
# サブスク（group_name でジャンル分け）
# ------------------------------------------------------------
Subscription.find_or_create_by!(name: '動画見放題パック') do |s|
  s.monthly_fee = 990
  s.group_name = 'エンタメ'
end
Subscription.find_or_create_by!(name: '音楽聴き放題パック') do |s|
  s.monthly_fee = 880
  s.group_name = 'エンタメ'
end
Subscription.find_or_create_by!(name: '端末保証パック') do |s|
  s.monthly_fee = 825
  s.group_name = '補償'
end
Subscription.find_or_create_by!(name: 'セキュリティパック') do |s|
  s.monthly_fee = 330
  s.group_name = '補償'
end

# ------------------------------------------------------------
# オプション（group_name でジャンル分け）
# ------------------------------------------------------------
Option.find_or_create_by!(name: '保護ガラスフィルム') do |o|
  o.price = 3300
  o.group_name = 'フィルム'
end
Option.find_or_create_by!(name: '保護フィルム') do |o|
  o.price = 1650
  o.group_name = 'フィルム'
end
Option.find_or_create_by!(name: '手帳型ケース') do |o|
  o.price = 4400
  o.group_name = 'ケース'
end
Option.find_or_create_by!(name: 'カバー型ケース') do |o|
  o.price = 3300
  o.group_name = 'ケース'
end
Option.find_or_create_by!(name: 'モバイルバッテリー') do |o|
  o.price = 5500
  o.group_name = ''
end
Option.find_or_create_by!(name: 'メモリーカード') do |o|
  o.price = 4400
  o.group_name = ''
end


# ------------------------------------------------------------
# 手数料（group_name でジャンル分け。支払いタイミングは
# シミュレーター画面で「当日払い／初月のみ」を都度選択する）
# ------------------------------------------------------------
Fee.find_or_create_by!(name: '事務手数料') do |f|
  f.price = 4950
  f.group_name = '事務手数料'
end
Fee.find_or_create_by!(name: '初期設定サポート料') do |f|
  f.price = 3300
  f.group_name = 'サポート手数料'
end
Fee.find_or_create_by!(name: 'データ移行手数料') do |f|
  f.price = 2200
  f.group_name = 'サポート手数料'
end

# ------------------------------------------------------------
# メーカー＆機種（group_name でグレード分け）
# ------------------------------------------------------------
maker_aurora = Maker.find_or_create_by!(name: 'Aurora')
maker_lumina = Maker.find_or_create_by!(name: 'Lumina')
maker_neon   = Maker.find_or_create_by!(name: 'Neon')

# Aurora（ハイエンド／スタンダード）
Device.find_or_create_by!(name: 'Aurora Z9 Pro', maker: maker_aurora) do |d|
  d.price = 159800
  d.release_date = Date.new(2025, 9, 20)
  d.group_name = 'ハイエンド'
end
Device.find_or_create_by!(name: 'Aurora Z9', maker: maker_aurora) do |d|
  d.price = 124800
  d.release_date = Date.new(2025, 9, 20)
  d.group_name = 'ハイエンド'
end
Device.find_or_create_by!(name: 'Aurora A5', maker: maker_aurora) do |d|
  d.price = 72800
  d.release_date = Date.new(2025, 3, 14)
  d.group_name = 'スタンダード'
end

# Lumina（ハイエンド／スタンダード）
Device.find_or_create_by!(name: 'Lumina Ultra X', maker: maker_lumina) do |d|
  d.price = 189800
  d.release_date = Date.new(2025, 2, 1)
  d.group_name = 'ハイエンド'
end
Device.find_or_create_by!(name: 'Lumina Air', maker: maker_lumina) do |d|
  d.price = 65780
  d.release_date = Date.new(2025, 5, 23)
  d.group_name = 'スタンダード'
end

# Neon（スタンダード／エントリー）
Device.find_or_create_by!(name: 'Neon S10', maker: maker_neon) do |d|
  d.price = 74800
  d.release_date = Date.new(2025, 7, 4)
  d.group_name = 'スタンダード'
end
Device.find_or_create_by!(name: 'Neon Lite', maker: maker_neon) do |d|
  d.price = 27800
  d.release_date = Date.new(2025, 1, 17)
  d.group_name = 'エントリー'
end

puts "サンプルデータの投入が完了しました。"
puts "ブランド: #{PlanBrand.count} / プラン: #{Plan.count} / 割引: #{Discount.count}"
puts "サブスク: #{Subscription.count} / オプション: #{Option.count} / 手数料: #{Fee.count}"
puts "メーカー: #{Maker.count} / 機種: #{Device.count} / ユーザー: #{User.count}"