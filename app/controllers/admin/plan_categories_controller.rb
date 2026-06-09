class Admin::PlanCategoriesController < Admin::BaseController
  before_action :set_plan_category, only: [:edit, :update, :destroy]

  def index
    @plan_categories = PlanCategory.all
  end

  def new
    @plan_category = PlanCategory.new
  end

  def create
    @plan_category = PlanCategory.new(plan_category_params)
    if @plan_category.save
      redirect_to admin_plan_categories_path, notice: 'プランカテゴリを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan_category.update(plan_category_params)
      redirect_to admin_plan_categories_path, notice: 'プランカテゴリを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan_category.destroy
    redirect_to admin_plan_categories_path, notice: 'プランカテゴリを削除しました'
  end

  private

  def set_plan_category
    @plan_category = PlanCategory.find(params[:id])
  end

  def plan_category_params
    params.require(:plan_category).permit(:name)
  end
end