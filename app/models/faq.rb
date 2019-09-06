class Faq
  include Mongoid::Document
  field :question, type: String
  field :answer, type: String

  belongs_to :client_application
end
