class Admin::PlanCombinationsController < Admin::BaseController
  before_action :set_plan_combination, only: [:destroy]

  def index
    @plan_combinations = PlanCombination.all.includes(:data_plan, :voice_plan)
  end

  def new
    @plan_combination = PlanCombination.new
    @data_plans = Plan.joins(:plan_category).where(plan_categories: { name: 'データプラン' })
    @voice_plans = Plan.joins(:plan_category).where(plan_categories: { name: '音声通話プラン' })
  end

  def create
    @plan_combination = PlanCombination.new(plan_combination_params)
    if @plan_combination.save
      redirect_to admin_plan_combinations_path, notice: 'プランの組み合わせを追加しました'
    else
      @data_plans = Plan.joins(:plan_category).where(plan_categories: { name: 'データプラン' })
      @voice_plans = Plan.joins(:plan_category).where(plan_categories: { name: '音声通話プラン' })
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @plan_combination.destroy
    redirect_to admin_plan_combinations_path, notice: 'プランの組み合わせを削除しました'
  end

  private

  def set_plan_combination
    @plan_combination = PlanCombination.find(params[:id])
  end

  def plan_combination_params
    params.require(:plan_combination).permit(:data_plan_id, :voice_plan_id)
  end
end