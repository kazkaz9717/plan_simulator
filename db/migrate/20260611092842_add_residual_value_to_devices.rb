class AddResidualValueToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :residual_value, :integer
  end
end
