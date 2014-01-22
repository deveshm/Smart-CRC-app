    
def create_base_defaults_for_email(email_details)

    
    emails_with_defaults = []
    table.hashes.each do | row |
      

    end

    default_installation_values = {
    'to' => default_installation.name,
    'attachment_content_type' => default_installation.phone,
    'subject' => default_installation.start_hour_of_concern,
    'body' => default_installation.end_hour_of_concern,
    'Designation' => default_installation.designation
  }



  installation_values_to_fill_in = default_installation_values.merge(required_install_details.rows_hash)
end


Given /^the following emails are to be retrived$/ do |table|

  stubbed_mails = []

  table.hashes.each do |row|

    mail = double("mail")

    MailStub.to(mail,[row["to"]])

    MailStub.from(mail,[row["from"]])

    in_reply_to_string = row['subject'] =~ /Re\:/ ? "yes" : row["in reply to"]

    MailStub.email_header(mail,
      row["from (header)"] ? row["from (header)"] : row["from"],
      in_reply_to_string)
 
    MailStub.attachments(self,mail,row['attachment'],row['attachment_content_type'])

    MailStub.message_id(mail,row['message_id'])

    MailStub.subject(mail,row['subject'])

    MailStub.body(self,mail,row['body'])
  
  	stubbed_mails << mail
  end
  Mail.stub(:defaults)
  Mail.stub(:all) { stubbed_mails}

end

Given /^the following emails are to be retrived by "(.*?)"$/ do |installation_name,table|

  designation = Installation.find_by_name(installation_name).designation
  sizeOfTable = table.raw[0].length
  raw_table = table.raw
  raw_table.each_with_index do |row,index|
    if index == 0
      row << "to"
    else
      row << "testemail+#{designation}@gmail.com"
    end
  end  
  
  step "the following emails are to be retrived",Cucumber::Ast::Table.new(raw_table)

end
 


When /^the email image synch is activated$/ do
	MailSynch.check_email
end