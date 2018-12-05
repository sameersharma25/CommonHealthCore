class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :note_text, type: String

  belongs_to :patient
end
