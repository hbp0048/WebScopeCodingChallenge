class ChangeColumnToNotNull < ActiveRecord::Migration
  def change
    change_column_null :bookings, :sender, false
    change_column_null :bookings, :recipient, false
    change_column_null :bookings, :pickup_addr, false
    change_column_null :bookings, :dropoff_addr, false
    change_column_null :bookings, :delivered, false
  end
end
