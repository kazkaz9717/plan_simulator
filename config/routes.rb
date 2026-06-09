Rails.application.routes.draw do
  root 'simulations#index'

  # ログイン・ログアウト
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  post   'guest_login', to: 'sessions#guest_login'
  delete 'logout', to: 'sessions#destroy'

  # シミュレーター
  resources :simulations, only: [:index]

  # 管理者専用
  namespace :admin do
    get "devices/index"
    get "devices/new"
    get "devices/edit"
    get "device_grades/index"
    get "device_grades/new"
    get "device_grades/edit"
    resources :plans
    resources :plan_categories
    resources :plan_combinations, only: [:index, :new, :create, :destroy]
    resources :subscriptions
    resources :options
    resources :makers
    resources :device_grades
    resources :devices
    resources :users
  end
end