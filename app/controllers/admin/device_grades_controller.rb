class Admin::DeviceGradesController < Admin::BaseController
  before_action :set_device_grade, only: [:edit, :update, :destroy]

  def index
    @device_grades = DeviceGrade.all
  end

  def new
    @device_grade = DeviceGrade.new
  end

  def create
    @device_grade = DeviceGrade.new(device_grade_params)
    if @device_grade.save
      redirect_to admin_device_grades_path, notice: 'デバイスグレードを追加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @device_grade.update(device_grade_params)
      redirect_to admin_device_grades_path, notice: 'デバイスグレードを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @device_grade.destroy
    redirect_to admin_device_grades_path, notice: 'デバイスグレードを削除しました'
  end

  private

  def set_device_grade
    @device_grade = DeviceGrade.find(params[:id])
  end

  def device_grade_params
    params.require(:device_grade).permit(:name)
  end
end