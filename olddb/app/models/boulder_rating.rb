class BoulderRating < ActiveRecord::Base
	attr_accessible :boulder_id, :user_id, :rating
  	belongs_to :boulder
  	belongs_to :user
  	validates_uniqueness_of :boulder, :scope => :user
end