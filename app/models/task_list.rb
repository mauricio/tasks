class TaskList < ActiveRecord::Base

  validates :title, presence: true, uniqueness: true
  serialize :tasks

end