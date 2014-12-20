class Event < ActiveRecord::Base
    attr_accessible :creator_id, :date_from, :date_to, :description, :goal, :period, :name, :participant_ids, :boulder_ids, :logo

    belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

    has_many :event_participants
    has_many :participants, :source => :user, :through => :event_participants

    has_many :event_boulders
    has_many :boulders, :source => :boulder, :through => :event_boulders

    mount_uploader :logo, EventLogoUploader

    validates :creator_id, :presence => true
    validates :goal, :presence => true
    validates :name, :presence => true
    validates :participant_ids, :presence => true
    validates :boulder_ids, :presence => true

    def is_active
        is_active = false
        if !self.period
            is_active = true
        else
            if self.date_from != nil && self.date_to != nil && self.date_from <= Date.today && self.date_to >= Date.today
            is_active = true
            end
        end
    end


    def updateParticipantTick

        # Ticks für boulder, die nicht im Event sind löschen
        ticks = BoulderConqueror.where({:event_id => self.id})
        ticks.each do |tick|
            boulder = Boulder.find(tick.boulder_id)
            if not self.boulders.include? boulder
                tick.delete
            end
        end

        # Prüfen, ob ein Teilnehmer eine Route bereits außerhalb des Events abgehakt hat. Falls ja, muss getickt werden
        self.participants.each do |user|
            self.boulders.each do |boulder|
                tickedAll = BoulderConqueror.where({:boulder_id => boulder.id, :event_id => 0, :user_id => user.id}).first()
                tickedEvent = BoulderConqueror.where({:boulder_id => boulder.id, :event_id => self.id, :user_id => user.id}).first()
                if tickedAll && !tickedEvent
                    if self.period
                        if (self.date_to+86399) >= tickedAll.created_at
                            ticked = BoulderConqueror.create({:boulder_id => boulder.id, :event_id => self.id, :type => tickedAll.type, :user_id => user.id})
                            ticked.save
                        end
                    else
                        ticked = BoulderConqueror.create({:boulder_id => boulder.id, :event_id => self.id, :type => tickedAll.type, :user_id => user.id})
                        ticked.save
                    end
                end
            end
		end

	end


	def get_locationID
		self.boulders.each { |boulder|
			location = boulder.get_location
			return location.id
		}
		return 0
	end

end
