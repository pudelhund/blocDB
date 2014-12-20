class BoulderCreator < ActiveRecord::Base
  attr_accessible :boulder_id, :user_id

  belongs_to :user
  belongs_to :boulder
end
