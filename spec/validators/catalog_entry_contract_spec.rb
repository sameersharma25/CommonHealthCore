require 'rails_helper'

RSpec.describe CatalogManagement::CatalogEntryContract, dbclean: :after_each do

  describe "with catalog entry params" do

    let(:params) do
      {catalog_data: { url: "test.com",
        GeoScope: {Scope: "Virtual", Neighborhoods: "test", ServiceAreaName: "test", State: "state", Country: "US", Region: "region", City: "city", County: "county" },
        OrganizationName: {InactiveCatalog: true, OrganizationName: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                           OrgDescription: [{Text: "easier", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                           OrganizationDescriptionDisplay: "orgsesdisplay", HomePageURL: "https://demo.commonhealthcore.org", Type: "Govt" },
        OrgSites: [{AdminSite: true, ServiceDeliverySite: true, ResourceDirectory: true, InactiveSite: true, LocationName: "test",
                    Webpage: "webpage", SiteReference: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    Addr1: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    Addr2: "address_2", AddrCity: "city", AddrState: "state", AddrZip: 22222, SelectSiteID: 1,
                    POCs: [{id: 1, poc: {Name: "ee", MobilePhone: 1234567890, OfficePhone: 1234567890, Email: "test@gmail.com", Title: "title",
                                         Referrals: "referal", ContactPage: "https://demo.commonhealthcore.org", defaultPOC: true}}] }],
        Programs: [{InactiveProgram: true, ProgramName: "pgname", ContactWebPage: "https://demo.commonhealthcore.org", QuickConnectWebPage: "https://demo.commonhealthcore.org",
                    ProgramWebPage: "https://demo.commonhealthcore.org", ProgramDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    ProgramDescriptionDisplay: "pdescdisplay", PopulationDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    PopulationDescriptionDisplay: "popdescdisplay", P_Any: true, P_Citizenship: true, P_Disabled: true, P_Family: true, P_LGBTQ: true,
                    P_LowIncome: true, P_Native: true, P_Other: true, P_Senior: true, P_Veteran: true, PopulationTags: "poptags",
                    ServiceAreaDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], ServiceAreaDescriptionDisplay: "sdescdisplay", S_Abuse: true, S_Addiction: true,
                    S_BasicNeeds: true, S_Behavioral: true, S_CaseManagement: true, S_Clothing: true, S_DayCare: true, S_Disabled: true, S_Education: true, S_Emergency: true, S_Employment: true, S_Family: true, S_Financial: true,
                    S_Food: true, S_GeneralSupport: true, S_Housing: true, S_Identification: true, S_IndependentLiving: true, S_Legal: true, S_Medical: true, S_Research: true, S_Resources: true, S_Respite: true, S_Senior: true, S_Transportation: true,
                    S_Veterans: true, S_Victim: true, ServiceTags: "stags", ProgramComment: "comment",
                    ProgramReferences: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], SelectprogramID: "new", ProgramSites: [1]}]}}
    end

    context 'for success case' do
      before do
        @result = subject.call(params)
      end

      it 'should be a container-ready operation' do
        expect(subject.respond_to?(:call)).to be_truthy
      end

      it 'should return Dry::Validation::Result object' do
        expect(@result).to be_a ::Dry::Validation::Result
      end

      it 'should not return any errors' do
        expect(@result.errors.to_h).to be_empty
      end
    end

    context 'for failure case' do
      before do
        @result = subject.call(params.tap{|p| p[:catalog_data].tap{|h| h.delete(:url)}})
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).not_to be_empty
      end

      it 'should return any errors' do
        expect(@result.errors.to_h).to eq({:catalog_data=>{:url=>["is missing"]}})
      end
    end
  end
end