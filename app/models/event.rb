class Event < ActiveRecord::Base
  attr_accessible  :event_type,:created_at,:note,:installation
  belongs_to :installation

  validates :installation_id, presence: true
  validates :event_type, presence: true
  validates :note, length: { maximum: 1000 }

  class EventType
  	HELP = "HELP"
  	OK = "OK"
  end

   def self.no_event_within(time_range,installation)
	  	event_in_range = Event.joins(:installation)
		    				.where(:installations => {id: installation.id},:created_at => time_range).first		
		  event_in_range == nil   				
	end

end
