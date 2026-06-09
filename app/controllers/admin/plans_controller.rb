class Admin::PlansController < Admin::BaseController
  before_action :set_plan, only: [:edit, :update, :destroy]

  def index
    @plans = Plan.all.includes(:plan_category)
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to admin_plans_path, notice: 'プランを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to admin_plans_path, notice: 'プランを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    redirect_to admin_plans_path, notice: 'プランを削除しました'
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee, :description, :plan_category_id)
  end
end