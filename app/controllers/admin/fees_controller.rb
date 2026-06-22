class Admin::FeesController < Admin::BaseController
  before_action :set_fee, only: [:edit, :update, :destroy]

  def index
    @fees = Fee.all.price_desc
  end

  def new
    @fee = Fee.new
  end

  def create
    @fee = Fee.new(fee_params)
    if @fee.save
      redirect_to admin_fees_path, notice: '手数料を追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @fee.update(fee_params)
      redirect_to admin_fees_path, notice: '手数料を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fee.destroy
    redirect_to admin_fees_path, notice: '手数料を削除しました'
  end

  private

  def set_fee
    @fee = Fee.find(params[:id])
  end

  def fee_params
    params.require(:fee).permit(:name, :price, :group_name)
  end
end