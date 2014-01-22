Given /^I view the list of installations$/ do
  visit installations_path
end


Given /^I choose to create a new Installation$/ do
  click_link "new_installation"
end



Then /^I shall see the following installations$/ do |table|
  TableHelper.compareTable(table,["Name","Phone","Designation"],"installation",page)
end


When /^I choose to send events for the installation "(.*?)"$/ do |installation_name|
     step %{I choose to perform the action "send_events" on the installation "#{installation_name}"}
end

When /^I choose to view the events of "(.*?)"$/ do |installation_name|
     step %{I choose to perform the action "view_events" on the installation "#{installation_name}"}
end

When /^I choose to view the alerts of "(.*?)"$/ do |installation_name|
     step %{I choose to perform the action "view_alerts" on the installation "#{installation_name}"}
end

When /^I choose to to edit the installation "(.*?)"$/ do |installation_name|
     step %{I choose to perform the action "edit" on the installation "#{installation_name}"}
end

When /^I choose to perform the action "(.*?)" on the installation "(.*?)"$/ do |action,installation_name|
     matched_row = page.all('#installations tr.installation').find do | row|
      row.find('.installation_name').text.should == installation_name
    end
    raise unless matched_row
    matched_row.find(".installation_#{action}").click
end

When /^I see an editable installation with the following values$/ do |required_install_details|

  installation_values_to_fill_in = required_install_details.rows_hash

  page.find("#installation_name").value.should == installation_values_to_fill_in['Name']
  page.find("#installation_phone").value.should == installation_values_to_fill_in['Phone']
  page.find("#installation_designation").value.should == installation_values_to_fill_in['Designation']
  page.find("#installation_start_hour_of_concern").value.should == installation_values_to_fill_in['Investigation Start']
  page.find("#installation_end_hour_of_concern").value.should == installation_values_to_fill_in['Investigation End']
end

When /^I attempt to update a installation with the following values$/ do |required_install_details|

  installation_values_to_fill_in = required_install_details.rows_hash

  InstallationStepHelper.fill_in_installation_values(page,installation_values_to_fill_in)
  click_button "update_installation"
end


When /^I update but not save an installation with the following values$/ do |required_install_details|
  installation_values_to_fill_in = required_install_details.rows_hash
  InstallationStepHelper.fill_in_installation_values(page,installation_values_to_fill_in)
end


Then /^I should see a message indicating that i have updated an installation$/ do
  page.has_css?(".alert-success").should == true
  page.should have_content("Your installation has been updated")
end

Then /^I print to console all Installations$/ do
  Installation.find(:all).each do | installation|
    pp installation
  end
end

Then /^the next investigation for installation "(.*?)" is at "(.*?)"$/ do |installation_name, expected_investigation_date|
  assert Installation.find_by_name(installation_name).next_investigation_time == Time.parse(expected_investigation_date) 
end

Then /^I choose to cancel the editing of the installation$/ do
  click_link "installation_edit_cancel"
end

Then /^i should be able to correct the error with the installation$/ do
  page.has_css?("#installation_edit_cancel").should == true
  page.has_css?("#update_installation").should == true
end

Then /^I choose to cancel the creation of the installation$/ do
  click_link "installation_create_cancel"
end

Given /^the installation "(.*?)" is sent an OK notification$/ do |installation_name|
  installation_with_ongoing_investigation = Installation.find_by_name(installation_name)
  installation_with_ongoing_investigation.events.build(event_type: Event::EventType::OK).save!
end

Given /^the installation "(.*?)" is sent an OK notification at "(.*?)"$/ do |installation_name, created_at|
  installation_with_ongoing_investigation = Installation.find_by_name(installation_name)
  Time.use_zone("Sydney") do
    installation_with_ongoing_investigation.events.build(event_type: Event::EventType::OK,created_at: Time.zone.parse(created_at)).save!
  end
end

Given /^the installation "(.*?)" is sent an Help request$/ do |installation_name|
  installation_with_ongoing_investigation = Installation.find_by_name(installation_name)
  installation_with_ongoing_investigation.events.build(event_type: Event::EventType::HELP).save!
end





