class UsageEvent < ActiveRecord::Base
  attr_accessible :installation_id, :time, :usage_event_type

  belongs_to :installation
  ON = 'ON'
  OFF = 'OFF'

  #validates :usage_event_type => { in: (ON OFF),message: "%{value} is not a valid type of usage event" }
end
