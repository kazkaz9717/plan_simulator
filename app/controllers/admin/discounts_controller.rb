class Admin::DiscountsController < Admin::BaseController
  before_action :set_discount, only: [:edit, :update, :destroy]

  def index
    if params[:plan_brand_id].present?
      @discounts = Discount.joins(:discount_plan_brands)
                          .where(discount_plan_brands: { plan_brand_id: params[:plan_brand_id] })
                          .includes(:plan_brands)
    else
      @discounts = Discount.all.includes(:plan_brands)
    end
    @plan_brands = PlanBrand.all
  end

  def new
    @discount = Discount.new
    @plan_brands = PlanBrand.all
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to admin_discounts_path, notice: '割引を追加しました'
    else
      @plan_brands = PlanBrand.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @plan_brands = PlanBrand.all
  end

  def update
    if @discount.update(discount_params)
      redirect_to admin_discounts_path, notice: '割引を更新しました'
    else
      @plan_brands = PlanBrand.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @discount.destroy
    redirect_to admin_discounts_path, notice: '割引を削除しました'
  end

  private

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def discount_params
     params.require(:discount).permit(:name, :amount, :duration_months, :group_name, plan_brand_ids: [])
  end
end