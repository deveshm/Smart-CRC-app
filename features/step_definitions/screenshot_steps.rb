Then /^I take a screenshot$/ do
	screenshot_and_save_page
end

Then /^I print out installations and conversations and messages$/ do
  Installation.find(:all).each {|installation| pp installation}
  Conversation.find(:all).each {|conversation| pp conversation}
  Message.find(:all).each {|message| pp message}
end
