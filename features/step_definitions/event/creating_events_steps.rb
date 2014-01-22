Then /^I should be able to send a event for "(.*?)"$/ do |name|
    found_install = Installation.find_by_name(name) 
    if found_install
        current_path.should  =~  /#{found_install.designation}/
    else
      current_path.should  =~  /#{name}/
    end      
    page.has_css?("#send_OK").should == true
end

Given /^the next event for "(.*?)" will fail to save$/ do |name|

  installation = Installation.find_by_name(name)
  event_list = double("event_list")
  event = Event.new

  installation.stub(:events) {event_list}
  event_list.stub(:build) {event}
  event_list.stub(:empty?) {true}

  Installation.stub(:find_by_designation) { installation }
  event.stub(:save) {false}

  conversation = installation.conversations[0]
  conversation.stub(:installation) {installation}
  Conversation.stub(:find) { conversation }
end


Then /^I should see a message indicating that I have sent an response$/ do
  page.has_css?(".alert-success").should == true
  page.should have_content("Your response has been sent")
end

Then /^I see an installation not present error page for installation "(.*?)"$/ do |invalid_conversation|
  page.should have_content("you have entered is no longer valid in the system")
  page.should have_content(invalid_conversation)
end


Then /^I see no last event$/ do
    page.has_css?("#last_ok_notification").should == false
end

Then /^I see the last ok event was at "(.*?)"$/ do |expected_last_event_time_as_string|
    Time.use_zone("Sydney") do
      expected_last_event_time_ = Time.zone.parse(expected_last_event_time_as_string)
      page.find("#last_ok_notification").should have_content(expected_last_event_time_.strftime("%A %I:%M %P"))
    end
end

Then /^the time range for the next checkin is from "(.*?)" to "(.*?)"$/ do |expected_start_time_as_string, expected_end_time_as_string|
    Time.use_zone("Sydney") do
      expected_start_time = Time.zone.parse(expected_start_time_as_string)
      expected_end_time = Time.zone.parse(expected_end_time_as_string)
      page.find("#next_checkin_times").should have_content(expected_start_time.strftime("%A %I:%M %P"))
      page.find("#next_checkin_times").should have_content(expected_end_time.strftime("%A %I:%M %P"))
    end
end

