require "rails_helper"

RSpec.describe CatalogManagement::CatalogEntityValidator, dbclean: :after_each do

  describe 'with catalog arguments' do

    let(:params) do
      { url: "test.com",
        GeoScope: {Scope: "Virtual", Neighborhoods: "test", ServiceAreaName: "test", State: "state", Country: "US", Region: "region", City: "city", County: "county" },
        OrganizationName: {InactiveCatalog: true, OrganizationName: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                           OrgDescription: [{Text: "easier", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                           OrganizationDescriptionDisplay: "orgsesdisplay", HomePageURL: "demo.commonhealthcore.org", Type: "Govt" },
        OrgSites: [{AdminSite: true, ServiceDeliverySite: true, ResourceDirectory: true, InactiveSite: true, LocationName: "test",
                    Webpage: "webpage", SiteReference: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    Addr1: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    Addr2: "address_2", AddrCity: "city", AddrState: "state", AddrZip: 22222, SelectSiteID: 1,
                    POCs: [{id: 1, poc: {Name: "ee", MobilePhone: 1234567890, OfficePhone: 1234567890, Email: "test@gmail.com", Title: "title",
                                         Referrals: "referal", ContactPage: "demo.commonhealthcore.org", defaultPOC: true}}] }],
        Programs: [{InactiveProgram: true, ProgramName: "pgname", ContactWebPage: "demo.commonhealthcore.org", QuickConnectWebPage: "demo.commonhealthcore.org",
                    ProgramWebPage: "demo.commonhealthcore.org", ProgramDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    ProgramDescriptionDisplay: "pdescdisplay", PopulationDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
                    PopulationDescriptionDisplay: "popdescdisplay", P_Any: true, P_Citizenship: true, P_Disabled: true, P_Family: true, P_LGBTQ: true,
                    P_LowIncome: true, P_Native: true, P_Other: true, P_Senior: true, P_Veteran: true, PopulationTags: "poptags",
                    ServiceAreaDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], ServiceAreaDescriptionDisplay: "sdescdisplay", S_Abuse: true, S_Addiction: true,
                    S_BasicNeeds: true, S_Behavioral: true, S_CaseManagement: true, S_Clothing: true, S_DayCare: true, S_Disabled: true, S_Education: true, S_Emergency: true, S_Employment: true, S_Family: true, S_Financial: true,
                    S_Food: true, S_GeneralSupport: true, S_Housing: true, S_Identification: true, S_IndependentLiving: true, S_Legal: true, S_Medical: true, S_Research: true, S_Resources: true, S_Respite: true, S_Senior: true, S_Transportation: true,
                    S_Veterans: true, S_Victim: true, ServiceTags: "stags", ProgramComment: "comment",
                    ProgramReferences: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], SelectprogramID: "new", ProgramSites: [1]}]}
    end


    describe 'with valid arguments' do


      it 'should initialize' do
        expect(CatalogManagement::CatalogEntityValidator.new(params)).to be_a CatalogManagement::CatalogEntityValidator
      end

      it 'should not raise error' do
        expect { CatalogManagement::CatalogEntityValidator.new(params) }.not_to raise_error
      end

      it 'should list all valid args' do
        expect(CatalogManagement::CatalogEntityValidator.new(params).to_h.keys).to eq  [:url, :GeoScope, :OrganizationName, :OrgSites, :Programs]
      end

      it 'should not raise error when optional argument missing' do
        expect { CatalogManagement::CatalogEntityValidator.new(params.tap{|p| p[:GeoScope].tap{|h| h.delete(:Neighborhoods)}}) }.not_to raise_error
      end

    end

    describe 'with invalid arguments' do
      it 'should raise error' do
        expect { subject }.to raise_error(Dry::Struct::Error, /:Scope is missing in Hash input/)
      end

      context "with unknown args" do
        it "should raise error" do
          expect { CatalogManagement::CatalogEntityValidator.new(params.merge!({PCitizenship: true})) }.to raise_error(Dry::Struct::Error, /unexpected keys \[:PCitizenship\] in Hash input/)
        end
      end

      context 'with invalid arg type' do
        it 'should raise error' do
          expect { CatalogManagement::CatalogEntityValidator.new(params.merge!({url: true})) }.to raise_error(Dry::Struct::Error, /has invalid type for :url violates constraints/)
        end
      end
    end
  end
end