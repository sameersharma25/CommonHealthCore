class PhiTable
  include Mongoid::Document
 	field :phi_key , type: String
    field :phi_value , type: Array
end
