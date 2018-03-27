json.extract! patient, :id, :first_name, :last_name, :created_at, :updated_at
json.url patient_url(patient, format: :json)
