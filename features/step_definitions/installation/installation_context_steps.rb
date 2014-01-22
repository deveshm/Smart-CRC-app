Then /^I shall see the following alerts for an installation$/ do |table|
  TableHelper.compareTable(table,["Type","Date/Time"],"lean_alert",page)
end

When /^I choose to view the events from the installation context$/ do
  click_link "installation_events"
end

Then /^I shall see the following events for an installation$/ do |table|
  TableHelper.compareTable(table,["Type","Date/Time"],"event",page)
end

When /^I choose to view the alerts from the installation context$/ do
  click_link "installation_alerts"
end

When /^I choose to send events from the installation context$/ do
  click_link "installation_send_event"
end


