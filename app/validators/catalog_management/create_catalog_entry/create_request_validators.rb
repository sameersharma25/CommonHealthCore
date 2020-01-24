module CatalogManagement
  module CreateCatalogEntry
    module CreateRequestValidators
      class PARAMS < ::CatalogManagement::BaseParamValidator
        define do
          required(:catalog_data).schema do
            required(:GeoScope).schema(CatalogManagement::CreateCatalogEntry::GeoScopeValidators::PARAMS)
            required(:OrganizationName).schema(CatalogManagement::CreateCatalogEntry::OrganizationNameValidators::PARAMS)
            required(:OrgSites).schema(CatalogManagement::CreateCatalogEntry::OrgSitesValidators::PARAMS)
            required(:Programs).array(CatalogManagement::CreateCatalogEntry::ProgramValidators::PARAMS)
            required(:url).value(:filled?, format?: /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/i)
          end
        end
      end
    end
  end
end