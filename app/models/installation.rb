class Installation < ActiveRecord::Base
  attr_accessible :name, :phone , :designation , :next_investigation_time, :created_at, :start_hour_of_concern, :end_hour_of_concern ,:photo_refreshes_per_day,:interrupt_duration, :medication_reminder, :medication_reminder_two, :medication_reminder_three
  has_many :events , :order => 'created_at DESC'
  has_many :alerts , :order => 'created_at DESC'
  has_many  :conversations , :dependent => :destroy
  has_many  :messages , :order => 'created_at'
  has_many :usage_events, :order => 'time'
  VALID_Designation_REGEX = /\A[A-Z0-9\-]*\z/i

  validates :name, presence: true, length: { maximum: 100 }
  validates :designation, presence: true, length: { maximum: 100,minimum: 4} , format: { with: VALID_Designation_REGEX} ,
    						uniqueness: { case_sensitive: false }
  validates :phone, presence: true, length: { maximum: 100 }
  validates :start_hour_of_concern, presence: true, :numericality => { greater_than: 0, less_than_or_equal_to: 23 }
  validates :end_hour_of_concern, presence: true, :numericality => { greater_than: 0, less_than_or_equal_to: 23 }
  validates :photo_refreshes_per_day, presence: true, :numericality => { greater_than: 0, less_than_or_equal_to: 1440 }
  validates :interrupt_duration, presence: true, :numericality => { greater_than: 0, less_than_or_equal_to: 1440 }
  validates :medication_reminder, :numericality => { greater_than: 0, less_than_or_equal_to: 23 }, allow_blank: true
  validates :medication_reminder_two, :numericality => { greater_than: 0, less_than_or_equal_to: 23 }, allow_blank: true
  validates :medication_reminder_three, :numericality => { greater_than: 0, less_than_or_equal_to: 23 }, allow_blank: true


    before_save { |installation| installation.designation = designation.downcase
                default_values
                }

  class State
    ONGOING_EMERGENCY = "ONGOING_EMERGENCY"
    ONGOING_INVESTIGATION = "ONGOING_INVESTIGATION"
    REQUIRE_CHECKIN = "REQUIRE_CHECKIN"
    SLEEPING = "SLEEPING"
  end

    def to_param
     designation
    end

    def roll_investigation_time!
      self.next_investigation_time = self.next_investigation_time + 3600*24
      self.save
    end  
    
    def within_checkin_period?
      current_active_time_range.cover? Time.zone.now
    end

    def after_checkin_period?
      current_active_time_range.end < Time.zone.now
    end    

    def has_events?
      if events.empty?
        return false
      else  
        events.first.event_type != nil
      end
    end

    def current_active_time_range
     if(end_hour_of_concern <= start_hour_of_concern)
          #if end hour of concern is after midnight, return range of time
          if  Time.zone.now.hour >= start_hour_of_concern
            # 
            (Time.zone.now.midnight + (start_hour_of_concern).hours)...((Time.zone.now + 1.day).midnight + (end_hour_of_concern).hours)
          else
            ((Time.zone.now - 1.day).midnight + (start_hour_of_concern).hours)...(Time.zone.now.midnight + (end_hour_of_concern).hours)
          end
      else
          #if start hour is on the same day as end hour
          (Time.zone.now.midnight + (start_hour_of_concern).hours)...(Time.zone.now.midnight + (end_hour_of_concern).hours)
      end
    end


  def next_active_time_range
    if ( after_checkin_period? || (within_checkin_period? && !Event.no_event_within(current_active_time_range,self) ) )
      current_active_time_range.begin+1.days...current_active_time_range.end+1.days  
    else
      current_active_time_range
    end  
  end   


  def state
    if(alerts.first != nil &&  alerts.first.alert_type == Alert::AlertType::EMERGENCY) 
      State::ONGOING_EMERGENCY
    elsif(alerts.first != nil &&  alerts.first.alert_type == Alert::AlertType::INVESTIGATION)  
      State::ONGOING_INVESTIGATION
    elsif within_checkin_period? && Event.no_event_within(current_active_time_range,self)
      State::REQUIRE_CHECKIN
    else 
      State::SLEEPING
    end 
  end

  def create_event(event_type) 
     event = self.events.build event_type: event_type
     event.save ? event : nil 
  end

  def add_usage_event
    now = Time.zone.now
    last_event = self.usage_events.last
    #two cases we have an event before that is less than 1 minute it should be an off event
    if !last_event || (now - last_event.time).minute  > 60
       #create a on event for now and an off 1 minute later
       self.usage_events.build(usage_event_type: 'ON', time:now)
       self.usage_events.build(usage_event_type: 'OFF', time: (now + 1.minute) )
       self.save
    else
    #  add 1 minute to the last one
      last_event.time = now + 1.minute
      last_event.save
    end
  end

    private
    def default_values
      day_of_investigation = Time.zone.now.tomorrow.change(hour: self.end_hour_of_concern) 
      day_of_investigation = Time.zone.now.change(hour: self.end_hour_of_concern) if Time.zone.now.hour < self.end_hour_of_concern 
      self.next_investigation_time ||= day_of_investigation
    end

end
