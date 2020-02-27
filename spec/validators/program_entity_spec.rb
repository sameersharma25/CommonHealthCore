require "rails_helper"

RSpec.describe CatalogManagement::ProgramEntity, dbclean: :after_each do

  describe 'with program arguents' do
    let(:params) do
      {InactiveProgram: true, ProgramName: "pgname", ContactWebPage: "demo.commonhealthcore.org", QuickConnectWebPage: "demo.commonhealthcore.org",
       ProgramWebPage: "demo.commonhealthcore.org", ProgramDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
       ProgramDescriptionDisplay: "pdescdisplay", PopulationDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}],
       PopulationDescriptionDisplay: "popdescdisplay", P_Any: true, P_Citizenship: true, P_Disabled: true, P_Family: true, P_LGBTQ: true,
       P_LowIncome: true, P_Native: true, P_Other: true, P_Senior: true, P_Veteran: true, PopulationTags: "poptags",
       ServiceAreaDescription: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], ServiceAreaDescriptionDisplay: "sdescdisplay", S_Abuse: true, S_Addiction: true,
       S_BasicNeeds: true, S_Behavioral: true, S_CaseManagement: true, S_Clothing: true, S_DayCare: true, S_Disabled: true, S_Education: true, S_Emergency: true, S_Employment: true, S_Family: true, S_Financial: true,
       S_Food: true, S_GeneralSupport: true, S_Housing: true, S_Identification: true, S_IndependentLiving: true, S_Legal: true, S_Medical: true, S_Research: true, S_Resources: true, S_Respite: true, S_Senior: true, S_Transportation: true,
       S_Veterans: true, S_Victim: true, ServiceTags: "stags", ProgramComment: "comment",
       ProgramReferences: [{Text: "test", Xpath: "p", Domain: "demo.commonhealthcore.org"}], SelectprogramID: "new", ProgramSites: [1]}
    end

    describe 'with valid arguments' do


      it 'should initialize' do
        expect(CatalogManagement::ProgramEntity.new(params)).to be_a CatalogManagement::ProgramEntity
      end

      it 'should not raise error' do
        expect { CatalogManagement::ProgramEntity.new(params) }.not_to raise_error
      end

      it 'should list all valid args' do
        expect(CatalogManagement::ProgramEntity.new(params).to_h.keys).to eq [:InactiveProgram,:ProgramName,:ContactWebPage,:QuickConnectWebPage,
                                                                              :ProgramWebPage,:ProgramDescription,:ProgramDescriptionDisplay,
                                                                              :PopulationDescription,:PopulationDescriptionDisplay,:P_Any,:P_Citizenship,
                                                                              :P_Disabled,:P_Family,:P_LGBTQ,:P_LowIncome,:P_Native,:P_Other,:P_Senior,
                                                                              :P_Veteran,:PopulationTags,:ServiceAreaDescription,:ServiceAreaDescriptionDisplay,
                                                                              :S_Abuse,:S_Addiction,:S_BasicNeeds,:S_Behavioral,:S_CaseManagement,:S_Clothing,
                                                                              :S_DayCare,:S_Disabled,:S_Education,:S_Emergency,:S_Employment,
                                                                              :S_Family,:S_Financial,:S_Food,:S_GeneralSupport,:S_Housing,:S_Identification,
                                                                              :S_IndependentLiving,:S_Legal,:S_Medical,:S_Research,:S_Resources,:S_Respite,:S_Senior,
                                                                              :S_Transportation,:S_Veterans,:S_Victim,:ServiceTags,:ProgramComment,
                                                                              :ProgramReferences,:SelectprogramID,:ProgramSites]
      end

      it 'should not raise error when optional argument missing' do
        expect { CatalogManagement::ProgramEntity.new(params.except(:ContactWebPage)) }.not_to raise_error
      end
    end

    describe 'with invalid arguments' do
      it 'should raise error' do
        expect { subject }.to raise_error(Dry::Struct::Error, /:ProgramName is missing in Hash input/)
      end

      context "with unknown args" do
        it "should raise error" do
          expect { CatalogManagement::ProgramEntity.new(params.merge!({PLowIncome: true})) }.to raise_error(Dry::Struct::Error, /unexpected keys \[:PLowIncome\] in Hash input/)
        end
      end

      context 'with invalid arg type' do
        it 'should raise error' do
          expect { CatalogManagement::ProgramEntity.new(params.merge!({InactiveProgram: 1})) }.to raise_error(Dry::Struct::Error, /has invalid type for :InactiveProgram violates constraints/)
        end
      end

    end
  end

end