class Wall < ActiveRecord::Base
  attr_accessible :description, :location_id, :name, :image

  belongs_to :location

  mount_uploader :image, WallImageUploader

  validates :name, :presence => true
  validates :location_id, :presence => true
end
