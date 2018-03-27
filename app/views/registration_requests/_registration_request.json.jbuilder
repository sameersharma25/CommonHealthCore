json.extract! registration_request, :id, :created_at, :updated_at
json.url registration_request_url(registration_request, format: :json)
