class BoulderDoubt < ActiveRecord::Base
  belongs_to :boulder
  belongs_to :user
  belongs_to :author, :class_name => "User", :foreign_key => :author_id
  attr_accessible :description, :status
end
