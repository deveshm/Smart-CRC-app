Then(/^I shake the device$/) do
  page.execute_script "sendMovement();"
end

And(/^I download the usage for all installations$/) do
   click_link "usage_installations"
end

Then(/^there are the following usages for "(.*?)"$/) do |installation, table|
  usage_events = table.hashes
  installation = Installation.where(name: installation).first
  usage_events.each{ |usage_event|
    installation.usage_events.where(usage_event_type: usage_event['type'],
                                    time:
                                        (Time.zone.parse(usage_event['Date']) - 1.second)..(Time.zone.parse(usage_event['Date']) + 1.second)).size.should eql(1)
  }
end