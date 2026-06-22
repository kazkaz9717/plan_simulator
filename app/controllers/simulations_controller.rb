class SimulationsController < ApplicationController
  before_action :require_login

  def index
    @plan_brands = PlanBrand.all.includes(plans: :plan_brands)
    @subscriptions = Subscription.all.price_desc
    @options = Option.all.price_desc
    @makers = Maker.all.includes(:devices)
    @discounts = Discount.all.includes(:plan_brands).amount_desc
    @fees = Fee.all.price_desc
  end
end