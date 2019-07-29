class PiiTable
  include Mongoid::Document
 	field :pii_key , type: String
    field :pii_value , type: Hash
end
