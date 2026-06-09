class Admin::MakersController < Admin::BaseController
  before_action :set_maker, only: [:edit, :update, :destroy]

  def index
    @makers = Maker.all
  end

  def new
    @maker = Maker.new
  end

  def create
    @maker = Maker.new(maker_params)
    if @maker.save
      redirect_to admin_makers_path, notice: 'メーカーを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @maker.update(maker_params)
      redirect_to admin_makers_path, notice: 'メーカーを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @maker.destroy
    redirect_to admin_makers_path, notice: 'メーカーを削除しました'
  end

  private

  def set_maker
    @maker = Maker.find(params[:id])
  end

  def maker_params
    params.require(:maker).permit(:name)
  end
end