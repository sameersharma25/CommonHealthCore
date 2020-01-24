module CatalogManagement
  module CreateCatalogEntry
    module CreateRequestWithEmailValidators

      class PARAMS < ::CatalogManagement::CreateCatalogEntry::CreateRequestValidators::PARAMS
        define do
          required(:email).value(:filled?, format?: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
        end
      end
    end
  end
end