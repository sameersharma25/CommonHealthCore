json.extract! appointment, :id, :date_of_appointment, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
