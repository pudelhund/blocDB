class Boulder < ActiveRecord::Base
  attr_accessible :climbers, :color_id, :description, :disable_date, :level_intern, :level_public, :manual_modified, :name, :points, :rating, :remove_date, :status, :votes, :wall_from, :wall_to, :creator_ids, :rating_count

  belongs_to :color
  belongs_to :wallfrom, :class_name => "Wall", :foreign_key => :wall_from
  belongs_to :wallto, :class_name => "Wall", :foreign_key => :wall_to

  has_many :boulder_creators
  has_many :creators, :source => :user, :through => :boulder_creators

  has_many :boulder_conquerors
  has_many :conquerors, :source => :user, :through => :boulder_conquerors

  has_many :comments

  has_many :event_boulders
  has_many :events, :through => :event_boulders

  validates :name, :presence => true
  validates :color_id, :presence => true
  validates :level_intern, :presence => true
  validates :level_public, :presence => true
  validates :creator_ids, :presence => true

  def is_mod
    if self.manual_modified.nil?
      return false
    end

    if self.manual_modified >= 1.week.ago
      return true
    end

    return false
  end


  def set_mod
    self.manual_modified = Time.now
    self.save
  end


  def remove_mod
    self.manual_modified = nil
    self.save
  end


  def deactivate
    self.status = 0
    self.remove_date = Time.now
    self.save
  end


  def get_location
    unless self.wall_from == nil
      location = Location.find(self.wallfrom.location.id)
      return location
    end
    unless self.wall_to == nil
      location = Location.find(self.wallto.location.id)
      return location
    end
  end
end
