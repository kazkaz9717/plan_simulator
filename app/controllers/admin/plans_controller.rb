class Admin::PlansController < Admin::BaseController
  before_action :set_plan, only: [:edit, :update, :destroy]

  def index
    if params[:plan_brand_id].present?
      @plans = Plan.joins(:plan_brand_plans)
                  .where(plan_brand_plans: { plan_brand_id: params[:plan_brand_id] })
                  .includes(:plan_brands).price_desc
    else
      @plans = Plan.all.includes(:plan_brands).price_desc
    end
    @plan_brands = PlanBrand.all
  end

  def new
    @plan = Plan.new
    @plan_brands = PlanBrand.all
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to admin_plans_path, notice: 'プランを追加しました'
    else
      @plan_brands = PlanBrand.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @plan_brands = PlanBrand.all
  end

  def update
    if @plan.update(plan_params)
      redirect_to admin_plans_path, notice: 'プランを更新しました'
    else
      @plan_brands = PlanBrand.all
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
    params.require(:plan).permit(:name, :monthly_fee, :group_name, plan_brand_ids: [])
  end
end