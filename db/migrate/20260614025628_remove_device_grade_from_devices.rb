class RemoveDeviceGradeFromDevices < ActiveRecord::Migration[7.2]
  def change
    remove_reference :devices, :device_grade, foreign_key: true
  end
end