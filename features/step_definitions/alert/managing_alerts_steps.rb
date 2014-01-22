Then /^I shall see the alerts displayed$/ do
  TableHelper.assert_table_is_present("lean_alert",page)
end


Then /^I shall see the following alerts$/ do |table|
  TableHelper.compareTable(table,["Type","Name","Phone","Date/Time"],"lean_alert",page)
end

When /^the system checks for Investigations$/ do
  EventAnalyzer.createAlerts
end

When /^I view the list of alerts$/ do
  visit alerts_path
end

Then /^I choose to add a note to the alert created at "(.*?)"$/ do |date_of_alert|
  page.first("#lean_alerts tr.lean_alert ##{date_of_alert.delete ': -'}").click
end

When /^I update the note of the alert to be "(.*?)"$/ do |note_content|
  fill_in "alert_note",         with: (StringExpander.expand_string(note_content))
  click_button "update_alert"
end

When /^I update the note of the alert to be too long$/ do 

  step %{I update the note of the alert to be "#{'a'*1001}"}
end



When /^I should be able to correct the error with the alert$/ do
  page.has_css?("#alert_edit_cancel").should == true
  page.has_css?("#update_alert").should == true
end

When /^I choose to cancel adding\/editing of the note of the alert$/ do
  click_link "alert_edit_cancel"
end

Given /^the alert created at "(.*?)" should indicate that it does not have an note$/ do |date_of_alert|
  page.first("#lean_alerts tr.lean_alert ##{date_of_alert.delete ': -'} .has_no_note").click
end

When /^the alert created at "(.*?)" should indicate that it has an note$/ do |date_of_alert|
  page.first("#lean_alerts tr.lean_alert ##{date_of_alert.delete ': -'} .has_note").click
end