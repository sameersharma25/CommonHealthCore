require 'uri'
require 'cgi'
require 'dry-types'

module CatalogManagement
  module Types
    include Dry.Types()
    include Dry::Logic

    Uri                 = Types.Constructor(::URI) { |val| ::URI.parse(val) }
    Url                 = Uri
    Email               = Coercible::String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    Emails              = Array.of(Email)
    CallableDateTime    = Types::DateTime.default { DateTime.now }
    PositiveInteger     = Coercible::Integer.constrained(gteq: 0)
    HashOrNil           = Types::Hash | Types::Nil
    CustomRange         = Types.Constructor(Types::Range) { |val| val[:min]..val[:max] }
    Bson                = Types.Constructor(BSON::ObjectId) { |val| BSON::ObjectId val }
    StringOrNil         = Types::String | Types::Nil
    StrippedString      = String.constructor(->(val){ String(val).strip })
  end
end
