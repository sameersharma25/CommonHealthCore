class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question, type: String

end
