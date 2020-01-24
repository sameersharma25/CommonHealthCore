module CatalogManagement
  module CreateCatalogEntry
    module GeoScopeValidators
      PARAMS = Dry::Schema.Params do
        optional(:City).value(:filled?)
        optional(:Country).value(:filled?)
        required(:Scope).maybe(:filled?)
        optional(:State).maybe(:filled?)
      end
    end
  end
end