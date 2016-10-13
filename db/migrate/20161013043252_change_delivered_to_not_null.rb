class ChangeDeliveredToNotNull < ActiveRecord::Migration
  def change
    change_column_null :bookings, :delivered, false
  end
end
