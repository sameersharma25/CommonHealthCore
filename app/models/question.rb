class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question, type: String
  field :pq, type: String
  field :nqy, type: String
  field :nqn, type: String


end
