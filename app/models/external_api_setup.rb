class ExternalApiSetup
  include Mongoid::Document
  include Mongoid::Timestamps

  field :api_name, type: String
  field :expected_parameters , type: Hash
  field :api_for, type: String

  belongs_to :client_application
  has_many :mapped_parameters

end