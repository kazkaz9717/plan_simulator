class Admin::OptionsController < Admin::BaseController
  before_action :set_option, only: [:edit, :update, :destroy]

  def index
    @options = Option.all.price_desc
  end

  def new
    @option = Option.new
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      redirect_to admin_options_path, notice: 'オプションを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @option.update(option_params)
      redirect_to admin_options_path, notice: 'オプションを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @option.destroy
    redirect_to admin_options_path, notice: 'オプションを削除しました'
  end

  private

  def set_option
    @option = Option.find(params[:id])
  end

  def option_params
    params.require(:option).permit(:name, :price, :group_name)
  end
end