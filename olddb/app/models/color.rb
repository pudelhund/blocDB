class Color < ActiveRecord::Base
  attr_accessible :name, :shortcut, :icon
  has_one :boulder

  mount_uploader :icon, IconUploader

  validates :name, :presence => true
end