class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :booking_id
      t.string :sender
      t.string :recepient
      t.date :booking_date
      t.string :pickup_addr
      t.string :dropoff_addr
      t.boolean :delivered

      t.timestamps null: false
    end
  end
end
