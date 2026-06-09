class SimulationsController < ApplicationController
  before_action :require_login

  def index
    @data_plans = Plan.joins(:plan_category)
                      .where(plan_categories: { name: 'データプラン' })
    @voice_plans = Plan.joins(:plan_category)
                      .where(plan_categories: { name: '音声通話プラン' })
    @plan_combinations = PlanCombination.all
    @subscriptions = Subscription.all
    @options = Option.all
    @devices = Device.all.includes(:maker, :device_grade)
  end
end