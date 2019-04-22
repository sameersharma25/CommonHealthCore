class MappedParameter
  include Mongoid::Document
  include Mongoid::Timestamps

  field :chc_parameter, type: String
  field :external_parameter, type: String
  field :api_name, type: String

  # belongs_to :client_application
  belongs_to :external_api_setup

end
