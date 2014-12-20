class BoulderError < ActiveRecord::Base
	belongs_to :boulder
	belongs_to :user
	attr_accessible :error, :status

	before_save :set_default

	protected

	def set_default
		self.status = 0 unless self.status
	end


	public

	def getLocationName		
		locationID = 0

		unless self.boulder.wallfrom.nil?
			locationID = self.boulder.wallfrom.location_id
		else 
			unless self.boulder.wallto.nil?
				locationID = self.boulder.wallto.location_id
			end
		end

		if locationID == 0
			return ''
		else	
			location = Location.find(locationID)
			return location.name
		end
	end

end
