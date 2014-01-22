Then /^I shall see the following events$/ do |table|
  TableHelper.compareTable(table,["Type","Name","Phone","Date/Time"],"event",page)
end

When /^I view the list of events$/ do
  visit events_path
end

Then /^I choose to add a note to the event created at "(.*?)"$/ do |date_of_event|
  page.first("#events tr.event ##{date_of_event.delete ': -'}").click
end

When /^I update the note of the event to be "(.*?)"$/ do |note_content|
  fill_in "event_note",     with: (StringExpander.expand_string note_content)
  click_button "update_event"
end

When /^I update the note of the event to be too long$/ do 

  step %{I update the note of the event to be "#{'a'*1001}"}
end

When /^I should be able to correct the error with the event$/ do
  page.has_css?("#event_edit_cancel").should == true
  page.has_css?("#update_event").should == true
end

When /^I choose to cancel adding\/editing of the note of the event$/ do
  click_link "event_edit_cancel"
end

Given /^the event created at "(.*?)" should indicate that it does not have an note$/ do |date_of_event|
  page.first("#events tr.event ##{date_of_event.delete ': -'} .has_no_note").click
end

When /^the event created at "(.*?)" should indicate that it has an note$/ do |date_of_event|
  page.first("#events tr.event ##{date_of_event.delete ': -'} .has_note").click
end