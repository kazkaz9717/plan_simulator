class Admin::DevicesController < Admin::BaseController
  before_action :set_device, only: [:edit, :update, :destroy]

  def index
    @devices = Device.all.includes(:maker, :device_grade)
  end

  def new
    @device = Device.new
    @makers = Maker.all
    @device_grades = DeviceGrade.all
  end

  def create
    @device = Device.new(device_params)
    if @device.save
      redirect_to admin_devices_path, notice: '機種を追加しました'
    else
      @makers = Maker.all
      @device_grades = DeviceGrade.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @makers = Maker.all
    @device_grades = DeviceGrade.all
  end

  def update
    if @device.update(device_params)
      redirect_to admin_devices_path, notice: '機種を更新しました'
    else
      @makers = Maker.all
      @device_grades = DeviceGrade.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @device.destroy
    redirect_to admin_devices_path, notice: '機種を削除しました'
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit(:name, :price, :description, :maker_id, :device_grade_id, :residual_value)
  end
end