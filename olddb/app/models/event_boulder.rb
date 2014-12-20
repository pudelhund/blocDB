class EventBoulder < ActiveRecord::Base
  attr_accessible :boulder_id, :event_id

  belongs_to :boulder
  belongs_to :event
end
