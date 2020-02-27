class InvalidCatalogEntry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :url, type: String
  field :catalog_hash, type: String
  field :error_hash, type: Hash
end
