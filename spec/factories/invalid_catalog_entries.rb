FactoryBot.define do
  factory :invalid_catalog_entry do
    email { 'test@gmail.com' }
    url { 'someurl.com' }
    catalog_hash { {} }
    error_hash { {} }
  end
end