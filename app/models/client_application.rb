class ClientApplication
  include Mongoid::Document
  field :name, type: String
  field :application_url, type: String
  # field :client_representative_id, type: String

  has_many :users, inverse_of: :client_application
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true
end
