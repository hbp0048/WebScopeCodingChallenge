class Booking < ActiveRecord::Base
    
  validates :sender, :presence =>  {:booking => "Sender can't be blank." }, :length => { minimum: 1 }
  validates :recipient, :presence => true, :length => { minimum: 1 }
  validates :pickup_addr, :presence => true
  validates :dropoff_addr, :presence => true
  
end
