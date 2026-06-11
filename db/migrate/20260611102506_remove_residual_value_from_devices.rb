class RemoveResidualValueFromDevices < ActiveRecord::Migration[7.2]
  def change
    remove_column :devices, :residual_value, :integer
  end
end
