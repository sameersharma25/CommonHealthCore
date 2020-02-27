require 'rails_helper'

RSpec.describe InvalidCatalogEntry, :type => :model do

  context "new model instance" do
    subject { described_class.new(email: "test@gmail.com", url: "test.com", catalog_hash: "{}", error_hash: {}) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

  end
end