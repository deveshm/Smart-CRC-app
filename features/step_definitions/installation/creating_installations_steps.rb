Given /^I am creating a new installation$/ do
  visit new_installation_path
end

When /^I attempt to create a installation with name "(.*)" and phone "(.*)" and designation "(.*)"$/ do |name,phone,designation|
  fill_in "installation_name",         with: name
  fill_in "installation_phone",        with: phone
  fill_in "installation_designation",        with: designation
  click_button "create_installation"
end



Then /^the most recently created installation should have the name "(.*)" and phone "(.*)"$/ do |name,phone|
  retrivedInstallation = Installation.find(:first,order: 'created_at DESC')
  assert retrivedInstallation.phone == phone
  assert retrivedInstallation.name == name
end

Then /^I should see a message indicating that i have created a installation$/ do
  page.has_css?(".alert-success").should == true
  page.should have_content("Your installation has been saved")
end



Then /^the installation "(.*?)" should have a conversation with the following details associated$/ do |installation_name, message_details|
  retrivedInstallation = Installation.find_by_name(installation_name)
  message_details = message_details.rows_hash



  assert retrivedInstallation.conversations[0].responds_via == message_details["responds_via"] , "should be #{message_details["responds_via"]} was #{retrivedInstallation.conversations[0].responds_via}" unless message_details["responds_via"].blank?
  assert retrivedInstallation.conversations[0].message_prefix == message_details["message_prefix"] , "should be #{message_details["message_prefix"]} was #{retrivedInstallation.conversations[0].message_prefix}" unless message_details["message_prefix"].blank?
  assert retrivedInstallation.conversations[0].external_message_id == message_details["external_message_id"] , "should be #{message_details["external_message_id"]} was #{retrivedInstallation.conversations[0].external_message_id}" unless message_details["external_message_id"].blank?
  assert retrivedInstallation.conversations[0].display_as == message_details["external_message_id"] , "should be #{message_details["external_message_id"]} was #{retrivedInstallation.conversations[0].external_message_id}" unless message_details["external_message_id"].blank?


end




When /^I attempt to create a installation with the following values$/ do |required_install_details|

  default_installation = FactoryGirl.build(:installation)

    default_installation_values = {
    'Name' => default_installation.name,
    'Phone' => default_installation.phone,
    'Investigation Start' => default_installation.start_hour_of_concern,
    'Investigation End' => default_installation.end_hour_of_concern,
    'Designation' => default_installation.designation
  }

  installation_values_to_fill_in = default_installation_values.merge(required_install_details.rows_hash)


  InstallationStepHelper.fill_in_installation_values(page,installation_values_to_fill_in)
  click_button "create_installation"
end
