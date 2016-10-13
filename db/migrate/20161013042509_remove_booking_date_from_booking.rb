class RemoveBookingDateFromBooking < ActiveRecord::Migration
  def change
    remove_column :bookings, :booking_date, :date
  end
end
