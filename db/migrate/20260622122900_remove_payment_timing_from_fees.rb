class RemovePaymentTimingFromFees < ActiveRecord::Migration[7.2]
  def change
    remove_column :fees, :payment_timing, :integer
  end
end
