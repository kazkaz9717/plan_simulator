User.find_or_create_by(name: 'guest') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :admin
end

# プランカテゴリ
data_category = PlanCategory.find_or_create_by(name: 'データプラン')
voice_category = PlanCategory.find_or_create_by(name: '音声通話プラン')

# データプラン
plan1 = Plan.find_or_create_by(name: 'ギガホプレミア') do |p|
  p.monthly_fee = 7315
  p.plan_category = data_category
end

plan2 = Plan.find_or_create_by(name: 'ギガライト') do |p|
  p.monthly_fee = 3465
  p.plan_category = data_category
end

# 音声通話プラン
voice1 = Plan.find_or_create_by(name: 'かけ放題オプション') do |p|
  p.monthly_fee = 1870
  p.plan_category = voice_category
end

voice2 = Plan.find_or_create_by(name: '5分通話無料オプション') do |p|
  p.monthly_fee = 880
  p.plan_category = voice_category
end

# プランの組み合わせ
PlanCombination.find_or_create_by(data_plan: plan1, voice_plan: voice1)
PlanCombination.find_or_create_by(data_plan: plan1, voice_plan: voice2)
PlanCombination.find_or_create_by(data_plan: plan2, voice_plan: voice2)

# サブスクリプション
Subscription.find_or_create_by(name: 'Lemino') do |s|
  s.monthly_fee = 990
end
Subscription.find_or_create_by(name: 'DAZN') do |s|
  s.monthly_fee = 3000
end

# オプション
Option.find_or_create_by(name: 'スマホケース') do |o|
  o.price = 3000
end
Option.find_or_create_by(name: 'フィルム') do |o|
  o.price = 2000
end

# メーカー
apple = Maker.find_or_create_by(name: 'Apple')
samsung = Maker.find_or_create_by(name: 'Samsung')

# グレード
standard = DeviceGrade.find_or_create_by(name: 'スタンダード')
highend = DeviceGrade.find_or_create_by(name: 'ハイエンド')

# 機種
Device.find_or_create_by(name: 'iPhone 15') do |d|
  d.price = 124800
  d.maker = apple
  d.device_grade = standard
end
Device.find_or_create_by(name: 'iPhone 15 Pro') do |d|
  d.price = 159800
  d.maker = apple
  d.device_grade = highend
end
Device.find_or_create_by(name: 'Galaxy S24') do |d|
  d.price = 124700
  d.maker = samsung
  d.device_grade = standard
end