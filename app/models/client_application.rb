class ClientApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :application_url, type: String
  field :service_provider_url, type: String
  field :external_application, type: Boolean
  field :accept_referrals, type: Boolean
  field :client_speciality, type: String
  field :master_application_status, type: Boolean
  field :organization_type, type: String
  field :organization_group, type: String

  # validates_presence_of :name, :application_url

  has_many :patients
  has_many :appointments
  has_many :notification_rules, inverse_of: :client_application
  has_many :users, inverse_of: :client_application
  has_many :referrals
  has_many :service_provider_details
  has_many :roles
  has_many :statuses
  has_many :external_api_setups
  has_many :interviews
  # has_many :mapped_parameters
  accepts_nested_attributes_for :users, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notification_rules, reject_if: :all_blank, allow_destroy: true

end
 