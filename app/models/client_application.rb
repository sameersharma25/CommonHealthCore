class ClientApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :application_url, type: String
  field :service_provider_url, type: String
  # field :client_representative_id, type: String

  # validates_presence_of :name, :application_url

  has_many :patients
  has_many :appointments
  has_many :notification_rules, inverse_of: :client_application
  has_many :users, inverse_of: :client_application
  has_many :referrals
  has_many :service_provider_details
  has_many :roles
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notification_rules, reject_if: :all_blank, allow_destroy: true

end
