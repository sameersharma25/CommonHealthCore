class QuestionResponse
  include Mongoid::Document
  include Mongoid::Timestamps

  field :question_id, type: String
  field :question_response, type: Boolean
  field :league_segments, type: Array


  belongs_to :client_application

end
