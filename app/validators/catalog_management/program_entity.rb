require 'dry-struct'

module CatalogManagement
  class ProgramEntity < Dry::Struct

    include Types

    schema schema.strict                                    # throw an error when unknown keys provided
    transform_keys(&:to_sym)                                # convert string keys to symbols

    attribute :InactiveProgram,                               Types::Strict::Bool.optional.meta(omittable: true)
    attribute :ProgramName,                                   Types::Strict::String
    attribute :ContactWebPage,                                Types::Strict::String.optional.meta(omittable: true)
    attribute :QuickConnectWebPage,                           Types::Strict::String.optional.meta(omittable: true)
    attribute :ProgramWebPage,                                Types::Strict::String.optional.meta(omittable: true)
    attribute? :ProgramDescription, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute :ProgramDescriptionDisplay,                     Types::Strict::String.optional.meta(omittable: true)
    attribute? :PopulationDescription, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute :PopulationDescriptionDisplay,                  Types::Strict::String.optional.meta(omittable: true)
    attribute :P_Any,                                         Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Citizenship,                                 Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Disabled,                                    Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Family,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_LGBTQ,                                       Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_LowIncome,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Native,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Other,                                       Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Senior,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :P_Veteran,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :PopulationTagss,                               Types::Strict::String.optional.meta(omittable: true)
    attribute? :ServiceAreaDescription, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute :ServiceAreaDescriptionDisplay,                 Types::Strict::String.optional.meta(omittable: true)
    attribute :S_Abuse,                                       Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Addiction,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_BasicNeeds,                                  Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Behavioral,                                  Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_CaseManagement,                              Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Clothing,                                    Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_DayCare,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Disabled,                                    Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Education,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Emergency,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Employment,                                  Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Family,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Financial,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Food,                                        Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_GeneralSupport,                              Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Housing,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Identification,                              Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_IndependentLiving,                           Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Legal,                                       Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Medical,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Research,                                    Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Resources,                                   Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Respite,                                     Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Senior,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Transportation,                              Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Veterans,                                    Types::Strict::Bool.optional.meta(omittable: true)
    attribute :S_Victim,                                      Types::Strict::Bool.optional.meta(omittable: true)
    attribute :ServiceTags,                                   Types::Strict::String.optional.meta(omittable: true)
    attribute :ProgramComment,                                Types::Strict::String.optional.meta(omittable: true)
    attribute? :ProgramReferences, Types::Strict::Array do
      attribute :Text,                                        Types::Strict::String.optional.meta(omittable: true)
      attribute :Xpath,                                       Types::Strict::String.optional.meta(omittable: true)
      attribute :Domain,                                      Types::Strict::String.optional.meta(omittable: true)
    end
    attribute :SelectprogramID,                               Types::Strict::String.optional.meta(omittable: true)
    attribute :ProgramSites,                                  Types::Strict::Array.of(Types::Coercible::Integer).optional.meta(omittable: true)
  end
end