require "rails_helper"

RSpec.describe CatalogManagement::SiteEntity, dbclean: :after_each do

  describe 'with site arguments' do

    let(:params) do
      { AdminSite: true, ServiceDeliverySite: true, ResourceDirectory: true, InactiveSite: true, LocationName: "test",
        Webpage: "webpage", SiteReference: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
        Addr1: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
        Addr2: "address_2", AddrCity: "city", AddrState: "state", AddrZip: 22222, SelectSiteID: 1,
        POCs: [{id: 1, poc: {Name: "ee", MobilePhone: 1234567890, OfficePhone: 1234567890, Email: "test@gmail.com", Title: "title",
                             Referrals: "referal", ContactPage: "demo.commonhealthcore.org", defaultPOC: true}}] }
    end

    describe 'with valid arguments' do

      it 'should initialize' do
        expect(CatalogManagement::SiteEntity.new(params)).to be_a CatalogManagement::SiteEntity
      end

      it 'should not raise error' do
        expect { CatalogManagement::SiteEntity.new(params) }.not_to raise_error
      end

      it 'should list all valid args' do
        expect(CatalogManagement::SiteEntity.new(params).to_h.keys).to eq  [:AdminSite, :ServiceDeliverySite, :ResourceDirectory, :InactiveSite,
                                                                            :LocationName, :Webpage, :SiteReference, :Addr1, :Addr2, :AddrCity,
                                                                            :AddrState, :AddrZip, :SelectSiteID, :POCs]
      end

      it 'should not raise error when optional argument missing' do
        expect { CatalogManagement::SiteEntity.new(params.except(:Webpage)) }.not_to raise_error
      end
    end

    describe 'with invalid arguments' do
      it 'should raise error' do
        expect { subject }.to raise_error(Dry::Struct::Error, /:LocationName is missing in Hash input/)
      end

      context "with unknown args" do
        it "should raise error" do
          expect { CatalogManagement::SiteEntity.new(params.merge!({Admin_Site: true})) }.to raise_error(Dry::Struct::Error, /unexpected keys \[:Admin_Site\] in Hash input/)
        end
      end

      context 'with invalid arg type' do
        it 'should raise error' do
          expect { CatalogManagement::SiteEntity.new(params.merge!({AdminSite: 1})) }.to raise_error(Dry::Struct::Error, /has invalid type for :AdminSite violates constraints/)
        end
      end
    end
  end
end