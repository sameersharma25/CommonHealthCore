class ShowTemplate
  include Mongoid::Document
  include Mongoid::Timestamps

  field :league_segments, type: Array
  field :agreement_type, type: String

end
