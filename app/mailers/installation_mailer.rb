class InstallationMailer < ActionMailer::Base

  def response_email response_text , conversation
  	@text = response_text
  	headers('In-Reply-To' => conversation.external_message_id)
    mail(reply_to: "#{ENV['EMAIL_NAME']}+#{conversation.installation.designation}@gmail.com" ,
         to: conversation.responds_via ,
         from: "#{ENV['EMAIL_NAME']}@gmail.com" ,
         subject: process_subject(conversation))
  end

  def process_subject conversation
  	if conversation.message_prefix =~ /Re\:/
  		conversation.message_prefix
  	else
  		"Re: #{conversation.message_prefix}"
  	end	
  end	
end


