require 'dry-struct'

module CatalogManagement
  class SiteEntity < Dry::Struct

    include CatalogManagement::Types

    schema schema.strict                                    # throw an error when unknown keys provided
    transform_keys(&:to_sym)                                # convert string keys to symbols

    attribute :AdminSite,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :ServiceDeliverySite,                           Types::Strict::Bool.optional.meta(omittable: true)
    attribute :ResourceDirectory,                             Types::Strict::Bool.optional.meta(omittable: true)
    attribute :InactiveSite,                                  Types::Strict::Bool.optional.meta(omittable: true)
    attribute :LocationName,                                  Types::Strict::String
    attribute :Webpage,                                       Types::Strict::String.optional.meta(omittable: true)
    attribute? :SiteReference, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute? :Addr1, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute :Addr2,                                         Types::Strict::String.optional.meta(omittable: true)
    attribute :AddrCity,                                      Types::Strict::String.optional.meta(omittable: true)
    attribute :AddrState,                                     Types::Strict::String.optional.meta(omittable: true)
    attribute :AddrZip,                                       Types::Coercible::Integer.optional.meta(omittable: true)
    attribute :SelectSiteID,                                  Types::Coercible::Integer.optional.meta(omittable: true)
    attribute? :POCs, Types::Strict::Array do
      attribute :id,                                          Types::Coercible::Integer.optional.meta(omittable: true)
      attribute? :poc do
        attribute :Name,                                      Types::Strict::String.optional.meta(omittable: true)
        attribute :MobilePhone,                               Types::Coercible::Integer.optional.meta(omittable: true)
        attribute :OfficePhone,                               Types::Coercible::Integer.optional.meta(omittable: true)
        attribute :Email,                                     Types::Strict::String.optional.meta(omittable: true)
        attribute :Title,                                     Types::Strict::String.optional.meta(omittable: true)
        attribute :Referrals,                                 Types::Strict::String.optional.meta(omittable: true)
        attribute :ContactPage,                               Types::Strict::String.optional.meta(omittable: true)
        attribute :defaultPOC,                                Types::Strict::Bool.optional.meta(omittable: true)
        attribute :InactivePOC,                               Types::Strict::Bool.optional.meta(omittable: true)
      end
    end
  end
end
