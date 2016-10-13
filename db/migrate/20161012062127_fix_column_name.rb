class FixColumnName < ActiveRecord::Migration 
  def change 
    rename_column :bookings, :recepient, :recipient 
  end 
end