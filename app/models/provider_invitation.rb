class ProviderInvitation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable

  field :org_url, type: String
  field :org_name, type: String
  field :org_invited_by, type: String


end