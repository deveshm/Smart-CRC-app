require 'spec_helper'

describe Installation do

  before { 
    @installation = Installation.new(name: "a"*100, phone: "a"*100, designation: "a"*100, start_hour_of_concern: 7, end_hour_of_concern: 11,photo_refreshes_per_day: 24,interrupt_duration: 10) 
  }

  subject { @installation }

  it { should respond_to(:name) }
  it { should respond_to(:phone) }
  it { should respond_to(:designation) }
  it { should respond_to(:next_investigation_time) }
  it { should respond_to(:start_hour_of_concern) }
  it { should respond_to(:end_hour_of_concern) }
  it { should respond_to(:photo_refreshes_per_day) }
  it { should respond_to(:interrupt_duration) }
  it { should respond_to(:conversations) }
  it { should respond_to(:events) }
  it { should respond_to(:alerts) }

  it { should be_valid }

  describe "when name is not present" do
    before { @installation.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @installation.name = "a"*101 }
    it { should_not be_valid }
  end

  describe "when phone is not present" do
    before { @installation.phone = " " }
    it { should_not be_valid }
  end

  describe "when phone is too long" do
    before { @installation.phone = "a"*101 }
    it { should_not be_valid }
  end

  describe "when designation is not present" do
    before { @installation.designation = " " }
    it { should_not be_valid }
  end

  describe "when designation is too long" do
    before { @installation.designation = "a"*101 }
    it { should_not be_valid }
  end

  describe "when designation is too short" do
    before { @installation.designation = "a"*3 }
    it { should_not be_valid }
  end

  describe "when designation format is valid" do
    it "should be invalid" do
      valid_designations = %w[aaaa 1111 -1111-aaa-]
      valid_designations.each do |valid_designation|
        @installation.designation = valid_designation
        @installation.should be_valid
      end      
    end
  end

  describe "when designation format is invalid" do
    it "should be invalid" do
      invalid_designations = %w[aa/a aa,a aa{a aa.a]
      invalid_designations.each do |invalid_designation|
        @installation.designation = invalid_designation
        @installation.should_not be_valid
      end      
    end
  end

  describe "when designation is already taken" do
    before do
      installation_with_same_designation = @installation.dup
      installation_with_same_designation.designation = @installation.designation.upcase
      installation_with_same_designation.save
    end

    it { should_not be_valid }
  end

  describe "when designation format is valid" do
    it "should be invalid" do
      valid_designations = %w[aaaa 1111 -1111-aaa-]
      valid_designations.each do |valid_designation|
        @installation.designation = valid_designation
        @installation.should be_valid
      end      
    end
  end  

  describe "when start_hour_of_concern is negative" do
    before { @installation.start_hour_of_concern = -1 }
    it { should_not be_valid }
  end

  describe "when start_hour_of_concern is over 23" do
    before { @installation.start_hour_of_concern = 24 }
    it { should_not be_valid }
  end

  describe "when start_hour_of_concern is nil" do
    before { @installation.start_hour_of_concern = nil }
    it { should_not be_valid }
  end

  describe "when end_hour_of_concern is negative" do
    before { @installation.end_hour_of_concern = -1 }
    it { should_not be_valid }
  end

  describe "when end_hour_of_concern is over 23" do
    before { @installation.end_hour_of_concern = 24 }
    it { should_not be_valid }
  end

  describe "when end_hour_of_concern is nil" do
    before { @installation.end_hour_of_concern = nil }
    it { should_not be_valid }
  end

  describe "when photo_refreshes_per_day is negative" do
    before { @installation.photo_refreshes_per_day = -1 }
    it { should_not be_valid }
  end

  describe "when photo_refreshes_per_day is over 1440" do
    before { @installation.photo_refreshes_per_day = 1441 }
    it { should_not be_valid }
  end

  describe "when photo_refreshes_per_day is nil" do
    before { @installation.photo_refreshes_per_day = nil }
    it { should_not be_valid }
  end  


  describe "when interrupt_duration is negative" do
    before { @installation.interrupt_duration = -1 }
    it { should_not be_valid }
  end

  describe "when interrupt_duration is over 1440" do
    before { @installation.interrupt_duration = 1441 }
    it { should_not be_valid }
  end

  describe "when interrupt_duration is nil" do
    before { @installation.interrupt_duration = nil }
    it { should_not be_valid }
  end 

  describe "should set next_investigation_date if not set" do
     it "should set it to end_hour_of_concern oclock the day after creation if end_hour_of_concern is past when created" do
        Time.use_zone("Sydney") do
          time = Time.parse("2011-10-10 18:10:10")
          Timecop.freeze(time) do
            timefrozenInstallation = FactoryGirl.create(:installation, end_hour_of_concern: 17)
            timefrozenInstallation.next_investigation_time.should == Time.zone.parse("2011-10-11 17:00:00")
          end 
        end
      end 

     it "should set it to end_hour_of_concern oclock the day of creation if end_hour_of_concern is in future when created" do
        Time.use_zone("Sydney") do
          time = Time.parse("2011-10-10 10:10:10")
          Timecop.freeze(time) do
            timefrozenInstallation = FactoryGirl.create(:installation, end_hour_of_concern: 17)
            timefrozenInstallation.next_investigation_time.should == Time.zone.parse("2011-10-10 17:00:00")
          end 
        end
      end
  end

  describe "should roll investigation to next day when asked" do
    it "should set it to same time the next day" do 
        Time.use_zone("Sydney") do
            @installation.next_investigation_time = Time.zone.parse("2012-12-31 12:00:00")
            @installation.roll_investigation_time!
            @installation.next_investigation_time.should == Time.zone.parse("2013-01-01 12:00:00")
        end
      end
  end


  describe "should say if determine if within timespan for checkin " do

       Time.use_zone("Sydney") do
          it "now is witin installation active period" do 
            valid_Times = [Time.parse('2011-10-10 07:00:00'),Time.parse('2011-10-10 10:59:59')]
            valid_Times.each do |time_within_active_range|
              Timecop.freeze(time_within_active_range) 
              @installation.within_checkin_period?.should == true
            end
          end
           it "now is not within installation active period" do 
            valid_Times = [Time.parse('2011-10-10 06:59:59'),Time.parse('2011-10-10 11:00:00')]
            valid_Times.each do |time_within_active_range|
              Timecop.freeze(time_within_active_range) 
              @installation.within_checkin_period?.should == false
            end
          end    
           it "installation active period spans midnight" do 
            installation_active_span_over_midnight = FactoryGirl.create(:installation, start_hour_of_concern: 21, end_hour_of_concern: 3)
            valid_Times = [Time.parse('2011-10-10 21:00:00'),Time.parse('2011-10-10 02:59:59')]
            valid_Times.each do |time_within_active_range|
              Timecop.freeze(time_within_active_range) 
              installation_active_span_over_midnight.within_checkin_period?.should == true
            end
          end                   
      end
  end


  describe "after  creating 2 events" do
      before { 
               @installation_with_events = FactoryGirl.create(:installation)
               @installation_with_events.save
               @first_created_event = @installation_with_events.events.build(event_type: Event::EventType::OK,note: "created first",created_at: Time.parse('2011-10-10 08:59:59'))
               @first_created_event.save
               @second_created_event = @installation_with_events.events.build(event_type: Event::EventType::OK,note: "created second",created_at: Time.parse('2011-10-10 09:00:00'))
               @second_created_event.save
      }

      it "should return the most recenty created event as the first event" do 
      Installation.find_by_id(@installation_with_events.id).events.first.should ==  @second_created_event 
      end
  end

  describe "after  creating 2 alerts" do
      before { 
               @installation_with_alerts = FactoryGirl.create(:installation)
               @installation_with_alerts.save
               @first_created_alert = @installation_with_alerts.alerts.build(alert_type: Alert::AlertType::EMERGENCY,note: "created first",created_at: Time.parse('2011-10-10 08:59:59'))
               @first_created_alert.save
               @second_created_alert = @installation_with_alerts.alerts.build(alert_type: Alert::AlertType::INVESTIGATION,note: "created second",created_at: Time.parse('2011-10-10 09:00:00'))
               @second_created_alert.save
      }

      it "should return the most recenty created event as the first event" do 
      Installation.find_by_id(@installation_with_alerts.id).alerts.first.should ==  @second_created_alert 
      end
  end

end
