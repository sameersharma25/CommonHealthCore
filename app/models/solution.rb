class Solution
  include Mongoid::Document
  include Mongoid::Timestamps

  field :solution_title, type: String
  field :solution_description, type: String


  belongs_to :obstacle
end
