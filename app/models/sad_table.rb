class SadTable
  include Mongoid::Document
 	field :sad_key , type: String
    field :sad_value , type: Array
end
