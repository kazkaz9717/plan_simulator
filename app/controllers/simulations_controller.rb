class SimulationsController < ApplicationController
  before_action :require_login

  def index
    @plan_brands = PlanBrand.all.includes(plans: :plan_brands)
    @subscriptions = Subscription.all.price_desc
    @options = Option.all.price_desc
    @devices = Device.all.includes(:maker).default_sorted
    @discounts = Discount.all.includes(:plan_brands)
  end
end