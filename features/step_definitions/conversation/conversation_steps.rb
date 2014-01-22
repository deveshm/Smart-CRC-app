Given /^installation "(.*?)" has the conversation$/ do |name, conversation_details|
  retrivedInstallation = Installation.find_by_name(name)
  if retrivedInstallation.conversations.empty?
    new_conversation = retrivedInstallation.conversations.build 
    new_conversation.save
    retrivedInstallation = Installation.find_by_name(install_name)
  end
  conversation_details_to_use = conversation_details.rows_hash
  retrivedInstallation.conversations[0].responds_via =  conversation_details_to_use["Responds Via"] if conversation_details_to_use["Responds Via"]
  retrivedInstallation.conversations[0].message_prefix =  conversation_details_to_use["Message Prefix"] if conversation_details_to_use["Message Prefix"]
  retrivedInstallation.conversations[0].external_message_id =  conversation_details_to_use["External Message id"] if conversation_details_to_use["External Message id"]
  retrivedInstallation.save

end


Given /^installation "(.*?)" (next|current) conversation has the (?:messages?|custom images?)$/ do |install_name,next_or_current, image_details|
  retrivedInstallation = Installation.find_by_name(install_name)
  conversation = retrivedInstallation.conversations.except(:order).order("created_at DESC").first
  if (conversation.nil? || next_or_current == "next" )
    conversation = retrivedInstallation.conversations.build() 
    conversation.save
  end

  image_details.hashes.each  do| row|
    built_image  = conversation.messages.build(installation: retrivedInstallation)
    built_image.photo = File.new(Rails.root.join('features', 'upload-files', row["Photo"])) if row["Photo"] && !row["Photo"].blank?
    built_image.text =  StringExpander.expand_string(row["Text"]) if row["Text"]
    built_image.message_type =  row["Type"] ||= Message::Type::EXTERNAL
    last_viewed =  Time.use_zone("Sydney") { Time.zone.parse(row["Last Viewed"]) if row["Last Viewed"] }
    built_image.last_display_in_carousel =  last_viewed if  last_viewed
    created_at =  Time.use_zone("Sydney") { Time.zone.parse(row["Created At"]) if row["Created At"] }
    built_image.created_at =  created_at  if created_at
    built_image.save
  end
end


Given /^installation "(.*?)" (next|current) conversation with "(.*?)" has the (?:messages?|custom images?)$/ do |install_name, next_or_current, responds_via ,image_details|
  retrivedInstallation = Installation.find_by_name(install_name)
  conversation = retrivedInstallation.conversations.except(:order).order("created_at DESC").where("responds_via = ?",responds_via).first
  if (conversation.nil? || next_or_current == "next" )
    conversation = retrivedInstallation.conversations.build(responds_via: reply_via) 
    conversation.save
  end


  image_details.hashes.each  do| row|
    built_image  = conversation.messages.build(installation: retrivedInstallation)
    built_image.photo = File.new(Rails.root.join('features', 'upload-files', row["Photo"])) if row["Photo"] && !row["Photo"].blank?
    built_image.text =  StringExpander.expand_string(row["Text"]) if row["Text"]
    built_image.message_type =  row["Type"] ||= Message::Type::EXTERNAL
    last_viewed =  Time.use_zone("Sydney") { Time.zone.parse(row["Last Viewed"]) if row["Last Viewed"] }
    built_image.last_display_in_carousel =  last_viewed if  last_viewed
    created_at =  Time.use_zone("Sydney") { Time.zone.parse(row["Created At"]) if row["Created At"] }
    built_image.created_at =  created_at  if created_at
    built_image.save
  end
end


Then /^the installation "(.*?)" current conversation should have the following (?:messages?|images?) associated$/ do |install_name, expected_images|
  retrivedInstallation = Installation.find_by_name(install_name)
  expected_image_hash = expected_images.hashes
  lastest_conversation = retrivedInstallation.conversations.except(:order).order("created_at DESC").first
  lastest_conversation.messages.length.should == expected_image_hash.length
  lastest_conversation.messages.each_with_index do | image,index|
    if "<BLANK>" == expected_image_hash[index]["text"]
      image.text.blank?.should == true;
    else
      StringExpander.expand_string(expected_image_hash[index]["text"]).should == image.text if expected_image_hash[index]["text"]  
    end 
    expected_image_hash[index]["photo"].should == image.photo_file_name if expected_image_hash[index]["photo"]
    expected_image_hash[index]["type"].should == image.message_type if expected_image_hash[index]["type"]
  end
end

Then /^the installation "(.*?)" current conversation with "(.*)"should have the following (?:messages?|images?) associated$/ do |install_name, responds_via,expected_images|
  retrivedInstallation = Installation.find_by_name(install_name)
  expected_image_hash = expected_images.hashes
  conversation = retrivedInstallation.conversations.except(:order).order("created_at DESC").where("responds_via = ?",responds_via).first
  lastest_conversation.messages.length.should == expected_image_hash.length
  lastest_conversation.messages.each_with_index do | image,index|
    if "<BLANK>" == expected_image_hash[index]["text"]
      image.text.blank?.should == true;
    else
      StringExpander.expand_string(expected_image_hash[index]["text"]).should == image.text if expected_image_hash[index]["text"]  
    end 
    expected_image_hash[index]["photo"].should == image.photo_file_name if expected_image_hash[index]["photo"]
    expected_image_hash[index]["type"].should == image.message_type if expected_image_hash[index]["type"]
  end
end


Then /^the installation "(.*?)" should have no image associated$/ do |installation_name|
  retrivedInstallation = Installation.find_by_name(installation_name)
  assert retrivedInstallation.conversations.empty? || retrivedInstallation.messages.where('photo_file_name is NOT NULL').empty?
end

Then /^the installation "(.*?)" should have no conversation associated$/ do |installation_name|
  retrivedInstallation = Installation.find_by_name(installation_name)
  assert retrivedInstallation.conversation.empty? == true
end