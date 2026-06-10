class Admin::PlanBrandsController < Admin::BaseController
  before_action :set_plan_brand, only: [:edit, :update, :destroy]

  def index
    @plan_brands = PlanBrand.all
  end

  def new
    @plan_brand = PlanBrand.new
  end

  def create
    @plan_brand = PlanBrand.new(plan_brand_params)
    if @plan_brand.save
      redirect_to admin_plan_brands_path, notice: 'プランブランドを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan_brand.update(plan_brand_params)
      redirect_to admin_plan_brands_path, notice: 'プランブランドを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan_brand.destroy
    redirect_to admin_plan_brands_path, notice: 'プランブランドを削除しました'
  end

  private

  def set_plan_brand
    @plan_brand = PlanBrand.find(params[:id])
  end

  def plan_brand_params
    params.require(:plan_brand).permit(:name)
  end
end