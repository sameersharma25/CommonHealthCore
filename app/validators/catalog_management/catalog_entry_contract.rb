require 'net/http'
require 'uri'

module CatalogManagement
  class CatalogEntryContract < ApplicationContract

    params do
      required(:catalog_data).hash do
        optional(:GeoScope).hash do
          required(:Scope).filled(:string)
          optional(:Neighborhoods).filled(:string)
          optional(:ServiceAreaName).filled(:string)
          optional(:State).filled(:string)
          optional(:Country).filled(:string)
          optional(:Region).filled(:string)
          optional(:City).filled(:string)
          optional(:County).filled(:string)
        end
        required(:OrganizationName).hash do
          optional(:InactiveCatalog).filled(:bool)
          required(:OrganizationName).array(:hash) do
            required(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:OrgDescription).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:OrganizationDescriptionDisplay).filled(:string)
          required(:HomePageURL).filled(:string)
          required(:Type).filled(:string)
        end
        optional(:OrgSites).array(:hash) do
          optional(:AdminSite).filled(:bool)
          optional(:ServiceDeliverySite).filled(:bool)
          optional(:ResourceDirectory).filled(:bool)
          optional(:InactiveSite).filled(:bool)
          required(:LocationName).filled(:string)
          optional(:Webpage).filled(:string)
          optional(:SiteReference).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:Addr1).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:Addr2).filled(:string)
          optional(:AddrCity).filled(:string)
          optional(:AddrState).filled(:string)
          optional(:AddrZip).filled(:integer)
          optional(:SelectSiteID).filled(:integer)
          optional(:POCs).array(:hash) do
            optional(:id).filled(:integer)
            optional(:poc).array(:hash) do
              optional(:Name).filled(:string)
              optional(:MobilePhone).filled(:integer)
              optional(:OfficePhone).filled(:integer)
              optional(:Email).filled(:string)
              optional(:Title).filled(:string)
              optional(:Referrals).filled(:string)
              optional(:ContactPage).filled(:string)
              optional(:defaultPOC).filled(:bool)
              optional(:InactivePOC).filled(:bool)
            end
          end
        end
        optional(:Programs).array(:hash) do
          optional(:InactiveProgram).filled(:bool)
          required(:ProgramName).filled(:string)
          optional(:ContactWebPage).filled(:string)
          optional(:QuickConnectWebPage).filled(:string)
          optional(:ProgramWebPage).filled(:string)
          optional(:ProgramDescription).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:ProgramDescriptionDisplay).filled(:string)
          optional(:PopulationDescription).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:PopulationDescriptionDisplay).filled(:string)
          optional(:P_Any).filled(:bool)
          optional(:P_Citizenship).filled(:bool)
          optional(:P_Disabled).filled(:bool)
          optional(:P_Family).filled(:bool)
          optional(:P_LGBTQ).filled(:bool)
          optional(:P_LowIncome).filled(:bool)
          optional(:P_Native).filled(:bool)
          optional(:P_Other).filled(:bool)
          optional(:P_Senior).filled(:bool)
          optional(:P_Veteran).filled(:bool)
          # optional(:PopulationTags).maybe(:string, :filled?) #TODO
          optional(:PopulationTagss).filled(:string)
          optional(:ServiceAreaDescription).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:ServiceAreaDescriptionDisplay).filled(:string)
          optional(:S_Abuse).filled(:bool)
          optional(:S_Addiction).filled(:bool)
          optional(:S_BasicNeeds).filled(:bool)
          optional(:S_Behavioral).filled(:bool)
          optional(:S_CaseManagement).filled(:bool)
          optional(:S_Clothing).filled(:bool)
          optional(:S_DayCare).filled(:bool)
          optional(:S_Disabled).filled(:bool)
          optional(:S_Education).filled(:bool)
          optional(:S_Emergency).filled(:bool)
          optional(:S_Employment).filled(:bool)
          optional(:S_Family).filled(:bool)
          optional(:S_Financial).filled(:bool)
          optional(:S_Food).filled(:bool)
          optional(:S_GeneralSupport).filled(:bool)
          optional(:S_Housing).filled(:bool)
          optional(:S_Identification).filled(:bool)
          optional(:S_IndependentLiving).filled(:bool)
          optional(:S_Legal).filled(:bool)
          optional(:S_Medical).filled(:bool)
          optional(:S_Research).filled(:bool)
          optional(:S_Resources).filled(:bool)
          optional(:S_Respite).filled(:bool)
          optional(:S_Senior).filled(:bool)
          optional(:S_Transportation).filled(:bool)
          optional(:S_Veterans).filled(:bool)
          optional(:S_Victim).filled(:bool)
          optional(:ServiceTags).filled(:string)
          optional(:ProgramComment).filled(:string)
          optional(:ProgramReferences).array(:hash) do
            optional(:Text).filled(:string)
            optional(:Xpath).filled(:string)
            optional(:Domain).filled(:string)
          end
          optional(:SelectprogramID).filled(:string)
          optional(:ProgramSites).array(:integer)
        end
        required(:url).filled(:string)
      end
    end

    #url rule
    rule(catalog_data: :url) do
      unless /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}$/i.match?(value)
        key.failure(:format?)
      end
    end

    # GeoScope rules
    rule(catalog_data: {GeoScope: :Country}) do
      key.failure(:type?, type:"US") if value.present? && value != "US"
    end

    rule(catalog_data: {GeoScope: :Scope}) do
      key.failure(:included_in?, list:["Virtual","National","Region","State","City","County","On Site"]) unless value.present? && ["Virtual","National","Region","State","City","County","On Site"].include?(value)
    end

    rule(catalog_data: {GeoScope: :Scope}) do
      homepageurl = values[:catalog_data][:OrganizationName][:HomePageURL]
      key.failure(:scope?, value:"HomePageURL", type:"Virtual") if value == "Virtual" && (homepageurl.blank? || homepageurl == "n/a")
    end

    rule(catalog_data: {GeoScope: :Scope}) do
      address = values[:catalog_data][:OrgSites].inject([]) do |address_text, site|
        address_text << site["addrOne_Text"] if site["addrOne_Text"].present? && site["addrOne_Text"] != "n/a"
      end
      key.failure(:scope?, value:"addrOne_Text", type:"On Site") if value == "On Site" && address.present?
    end

    rule(catalog_data: {GeoScope: :State}) do
      key.failure(:scope?, value:"State", type:"State") if values[:catalog_data][:GeoScope][:Scope] == "State" && (value.blank? || value == "n/a")
    end

    rule(catalog_data: {GeoScope: :Region}) do
      key.failure(:scope?, value:"Region", type:"Region") if values[:catalog_data][:GeoScope][:Scope] == "Region" && (value.blank? || value == "n/a")
    end

    rule(catalog_data: {GeoScope: :Country}) do
      key.failure(:scope?, value:"Country", type:"National") if values[:catalog_data][:GeoScope][:Scope] == "National" && (value.blank? || value == "n/a")
    end

    rule(catalog_data: {GeoScope: :County}) do
      key.failure(:scope?, value:"County", type:"County") if values[:catalog_data][:GeoScope][:Scope] == "County" && (value.blank? || value == "n/a")
    end

    rule(catalog_data: {GeoScope: :City}) do
      key.failure(:scope?, value:"City", type:"City") if values[:catalog_data][:GeoScope][:Scope] == "City" && (value.blank? || value == "n/a")
    end

    # organization rules
    rule(catalog_data: {OrganizationName: :HomePageURL}) do
      url = URI.parse(value)
      unless url &&  url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        key.failure(:format?)
      end
    end

    rule(catalog_data: {OrganizationName: :HomePageURL}) do
      unless (Net::HTTP.get_response(URI(value)).code rescue nil) == "200"
        key.failure(:invalid_url)
      end
    end

    # program rules
    rule(catalog_data: :Programs).each do

      url = URI.parse(value[:ContactWebPage])
      unless url &&  url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        # key(catalog_data: {Programs: {keys[0][2]=> :ContactWebPage}}).failure('is invalid')
        # key.failure("ContactWebPage has invalid format")
        key(catalog_data: {Programs: {value[:ProgramName]=> :ContactWebPage}}).failure(:format?)
      end

      unless (Net::HTTP.get_response(URI(value[:ContactWebPage])).code rescue nil) == "200"
        key(catalog_data: {Programs: {value[:ProgramName]=> :ContactWebPage}}).failure(:invalid_url)
      end

      url = URI.parse(value[:QuickConnectWebPage])
      unless url &&  url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        key(catalog_data: {Programs: {value[:ProgramName]=> :QuickConnectWebPage}}).failure(:format?)
      end

      unless (Net::HTTP.get_response(URI(value[:QuickConnectWebPage])).code rescue nil) == "200"
        key(catalog_data: {Programs: {value[:ProgramName]=> :QuickConnectWebPage}}).failure(:invalid_url)
      end

      url = URI.parse(value[:ProgramWebPage])
      unless url &&  url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        key(catalog_data: {Programs: {value[:ProgramName]=> :ProgramWebPage}}).failure(:format?)
      end

      unless (Net::HTTP.get_response(URI(value[:QuickConnectWebPage])).code rescue nil) == "200"
        key(catalog_data: {Programs: {value[:ProgramName]=> :ProgramWebPage}}).failure(:invalid_url)
      end

      if value[:P_Other] == true && value[:PopulationTags].blank?
        key(catalog_data: {Programs: {value[:ProgramName]=> :PopulationTags}}).failure(:attr?)
      end
    end
  end
end