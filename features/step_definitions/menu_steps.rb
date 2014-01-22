
Given /^I have landed on Lean$/ do
  visit "/"
end

Given /^From the menu I choose to view the List of Events$/ do
  click_link "list_events_link"
end

Given /^From the menu I choose to view the Home page$/ do
  click_link "home_link"
end

Given /^From the menu I choose to view the List of Installations$/ do
  click_link "list_installations_link"
end

Then /^I should see the Home page menu item highlighted$/ do
    page.has_css?(".active #home_link").should == true
end

Then /^I should see the List of Installations page menu item highlighted$/ do
    page.has_css?(".active #list_installations_link").should == true
end

Then /^I should see the List of Events page menu item highlighted$/ do
    page.has_css?(".active #list_events_link").should == true
end

Then /^From the menu I choose to view the List of Alerts$/ do
  click_link "list_alerts_link"
end

Then /^I should see the List of Alerts page menu item highlighted$/ do
    page.has_css?(".active #list_alerts_link").should == true
end

When /^I see the following installation details on the installation banner$/ do |expected_installation_details|	
  as_map = expected_installation_details.rows_hash
  banner = page.find('#installation_banner')
  banner.find('#installation_name').text.should == as_map['Name']
  banner.find('#installation_phone').text.should == as_map['Phone']
  banner.find('#installation_designation').text.should == as_map['Designation']
end

Then /^I do not see the lean menu$/ do
  page.has_css?('#lean_menu').should == false
end
