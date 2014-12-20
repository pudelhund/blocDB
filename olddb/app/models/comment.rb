class Comment < ActiveRecord::Base
  attr_accessible :author_id, :boulder_id, :text, :vote

  belongs_to :boulder
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
end
