class Ranking < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  attr_accessible :conquer_count, :points, :status, :gender
  attr_accessor :rank, :groupText



end
