class AboutU
  include Mongoid::Document
    field :body, type: String

    belongs_to :client_application
end 

