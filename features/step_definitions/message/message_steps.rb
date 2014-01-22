
When /^I choose to navigate to the view the message of the installation$/ do
  click_link "view_messages"
end

Then /^I see the message "(.*?)"$/ do |message_text|
  page.find('#message').text.should == message_text
end

When /^I choose not to view messages$/ do
  click_link "return_to_send_events"
end

Given /^I am viewing the messages of installation "(.*?)"$/ do |installation_name|
  visit messages_installation_path(Installation.find_by_name(installation_name))
end

When /^I respond to the current message with "(.*?)"$/ do |reponse_text| 
	fill_in "reply_text",     with: (StringExpander.expand_string reponse_text)
	click_button "Reply"
end

Then /^installation "(.*?)" conversation for "(.*?)" has the message "(.*?)"$/ do |installation_name, conversation_responds_via, expected_content|
	assert Installation.find_by_name(installation_name).conversations[0].messages.index{ | message | message.text == StringExpander.expand_string(expected_content) } != nil
end

Then /^installation "(.*?)" conversation for "(.*?)" has no messages$/ do |installation_name, conversation_responds_via|
	assert Installation.find_by_name(installation_name).conversations[0].messages.empty? == true
end

Then /^I shall see the following messages$/ do |table|
  TableHelper.compareTable(table,["Content","Type"],"message",page)
end

When /^I am viewing the the most recent conversation for installation "(.*?)"$/ do |installation_name|
  visit messages_conversation_path(Installation.find_by_name(installation_name).conversations.last)
end

Then /^I can see that the messages have been sent by "(.*?)"$/ do |message_sender|
  page.find('#conversation_header').should have_content message_sender
end
