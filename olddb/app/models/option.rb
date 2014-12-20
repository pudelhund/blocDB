class Option < ActiveRecord::Base
	attr_accessible :location_id, :name, :value

	belongs_to :location

	validates :name, :presence => true
	validates :location_id, :presence => true
end
