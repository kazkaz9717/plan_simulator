User.find_or_create_by(name: 'guest') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :admin
end