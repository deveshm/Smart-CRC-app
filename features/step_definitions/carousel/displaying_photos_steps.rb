Then /^I expect to see the following photos at the following times when viewing the carousel of "(.*?)"$/ do |install_name, expected_photos|

  expected_photos.hashes.each do | row|
    step %{the datetime is reset to "#{row['time']}" but time continues to pass}
    step %{I view the carousel for installation "#{install_name}"}
    step %{the caption "#{row['caption']}" is displayed on the page}
    step %{the photo "#{row['photo']}" is displayed on the page} if row['photo']
  end 
end

Given /^I view the carousel for installation "(.*?)"$/ do |name|
  found_install = Installation.find_by_name(name) 
  if found_install
    visit new_installation_event_path(found_install.designation)
  else
   visit new_installation_event_path(name)
  end
end

Then /^the caption "(.*?)" is displayed on the page$/ do |caption_text|
  page.find("#photo_caption").should have_content(StringExpander.expand_string(caption_text))
end

Then /^the photo "(.*?)" is displayed on the page$/ do |expected_photo_name|
    if expected_photo_name == "<Default Image>"
      page.has_css?(".default_carer_image").should == true
    else  
      page.has_css?("##{expected_photo_name.gsub(/\W/,'')}").should == true 
    end
end


Then /^I see that the photo is from "(.*?)"$/ do |name_text|
    page.find("#recieved_by").should have_content(name_text)
end

Then /^no caption is shown$/ do 
  page.has_css?("#photo_caption").should == false
end


When /^I swipe left$/ do
  page.execute_script("swipeleftHandler()")
  #selenium_webdriver = page.driver.browser
  #
  #selenium_webdriver.mouse.move_to(selenium_webdriver.find_element(class: "span3"), 0, 0)
  #selenium_webdriver.mouse.down
  #selenium_webdriver.mouse.move_by( -50, 0)
  #selenium_webdriver.mouse.up
end

When(/^I swipe right$/) do
  page.execute_script("swiperightHandler()")
end