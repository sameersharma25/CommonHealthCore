require 'dry-struct'

module CatalogManagement
  class CatalogEntityValidator < Dry::Struct

    include Types

    schema schema.strict                                    # throw an error when unknown keys provided
    transform_keys(&:to_sym)                                # convert string keys to symbols

    attribute :url,                                             Types::Strict::String

    attribute? :GeoScope do
      attribute :Scope,                                         Types::Strict::String
      attribute :Neighborhoods,                                 Types::Strict::String.optional.meta(omittable: true)
      attribute :ServiceAreaName,                               Types::Strict::String.optional.meta(omittable: true)
      attribute :State,                                         Types::Strict::String.optional.meta(omittable: true)
      attribute :Country,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Region,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :City,                                          Types::Strict::String.optional.meta(omittable: true)
      attribute :County,                                        Types::Strict::String.optional.meta(omittable: true)
    end

    attribute? :OrganizationName do
      attribute :InactiveCatalog,                               Types::Strict::Bool.optional.meta(omittable: true)
      attribute? :OrganizationName,Types::Strict::Array do
        attribute :Text,                                        Types::Strict::String
        attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
        attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
      end
      attribute? :OrgDescription, Types::Strict::Array do
        attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
        attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
        attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
      end
      attribute :OrganizationDescriptionDisplay,                Types::Strict::String.optional.meta(omittable: true)
      attribute :HomePageURL,                                   Types::Strict::String
      attribute :Type,                                          Types::Strict::String
    end

    attribute :OrgSites,                                        Types::Strict::Array.of(CatalogManagement::SiteEntity).optional.meta(omittable: true)

    attribute :Programs,                                        Types::Strict::Array.of(CatalogManagement::ProgramEntity).optional.meta(omittable: true)
  end
end





