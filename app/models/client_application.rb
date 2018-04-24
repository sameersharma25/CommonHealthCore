class ClientApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :application_url, type: String
  # field :client_representative_id, type: String

  # validates_presence_of :name, :application_url

  has_many :patients
  has_many :appointments
  has_many :users, inverse_of: :client_application
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true
end
