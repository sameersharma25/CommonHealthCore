class Task
  include Mongoid::Document

  field :task_type, type: String
end
