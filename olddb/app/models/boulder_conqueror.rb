class BoulderConqueror < ActiveRecord::Base
	set_inheritance_column :ruby_type

	attr_accessible :boulder_id, :event_id, :type, :user_id

	belongs_to :user
	belongs_to :boulder
	belongs_to :event
end