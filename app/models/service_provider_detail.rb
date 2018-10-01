class ServiceProviderDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :service_provider_name, type: String
  field :provider_type, type: String
  field :share, type: Boolean
  field :data_storage_type, type: String
  field :service_provider_api, type: String
  field :filtering_fields, type: Hash

  belongs_to :client_application

  validates :service_provider_name, presence: true
end
