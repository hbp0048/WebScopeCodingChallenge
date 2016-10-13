json.extract! booking, :id, :booking_id, :sender, :recepient, :booking_date, :pickup_addr, :dropoff_addr, :delivered, :created_at, :updated_at
json.url booking_url(booking, format: :json)