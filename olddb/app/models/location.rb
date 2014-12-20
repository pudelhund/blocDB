class Location < ActiveRecord::Base
	attr_accessible :address, :name, :banner, :logo

	mount_uploader :banner, LocationBannerUploader
	mount_uploader :logo, LocationLogoUploader

	has_one :wall
	has_one :option
end
