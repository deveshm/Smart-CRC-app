Given /^I see the default sleeping carousel$/ do
    page.has_css?(".default_carer_image").should == true
end

Then /^I see the custom sleeping carousel$/ do
    page.has_css?(".custom_carer_image").should == true
end

Then /^I see the default investigation carousel$/ do
    page.has_css?("#default_investigation_image").should == true
end

Then /^I see the requesting checkin carousel$/ do
    page.has_css?(".requiring_checkin").should == true
end

Then /^I see the ongoing investigation carousel$/ do
    page.has_css?(".investigation_ongoing").should == true
end 

When /^I send an OK notification$/ do
  step "I see Ok Notifications are allowed"
  click_button "send_OK"
end

Then /^I should see a message indicating that I have sent a OK notification$/ do
  page.should have_content("Your OK notification has been processed")
end

Then /^I see Ok Notifications are not allowed$/ do
   page.has_css?("#send_OK").should == false
end

Then /^I see Ok Notifications are allowed$/ do
   assert page.has_css?("#send_OK")
   assert page.find('#send_OK')[:disabled].should == nil 
end