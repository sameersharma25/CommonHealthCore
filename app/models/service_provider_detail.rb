class ServiceProviderDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :service_provider_name, type: String
  field :provider_type, type: String
  field :share, type: Boolean
  field :data_storage_type, type: String
  field :service_provider_api, type: String
  field :filtering_fields, type: Hash
  field :coordinates_provided, type: Boolean
  field :lat_name, type: String
  field :long_name, type: String

  belongs_to :client_application

  validates :service_provider_name, presence: true
  validates :data_storage_type , presence: true
end
