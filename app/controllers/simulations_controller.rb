class SimulationsController < ApplicationController
  before_action :require_login

  def index
    @plan_brands = PlanBrand.all.includes(plans: :plan_brands)
    @subscriptions = Subscription.all
    @options = Option.all
    @devices = Device.all.includes(:maker, :device_grade)
    @discounts = Discount.all
  end
end