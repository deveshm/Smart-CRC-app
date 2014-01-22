

module MailStub

	

	def self.attachments(cucumber,mail,passed_attachment_names,passed_attachment_contenttypes)
      	attachment_list = [] 

		if !passed_attachment_names.blank?
		      attachment_names = passed_attachment_names.split(",")
			  attachment_contenttypes = passed_attachment_contenttypes.split(",") unless passed_attachment_contenttypes.blank?
			  attachment_names.each_with_index do |attachment_name , index|

			    attachment_body = cucumber.double("attachment_body")
			    attachment_body.stub(:decoded) { File.open(File.join(Rails.root, 'features', 'upload-files', attachment_name)).read}

			    attachment = cucumber.double("attachment")
			    attachment.stub(:body) { attachment_body}
			    attachment.stub(:filename) { attachment_name}
			    attachment.stub(:mime_type) { attachment_contenttypes[index]} if attachment_contenttypes
			    attachment.stub(:mime_type) { "image/jpg"} unless attachment_contenttypes

			    attachment_list << attachment
		  	end  
		end
  		mail.stub(:attachments) {attachment_list}
 	end

	def self.to(mail,to_list)
		list_of_recieptients = to_list
		mail.stub(:to) {list_of_recieptients}
	end

	def self.from(mail,from_list)
		mail.stub(:from) {from_list}
	end	

	def self.email_header(mail,from_header_value,in_reply_to_value)
		header = {}
		header['From'] = from_header_value unless from_header_value.blank?
		header['In-Reply-To'] = in_reply_to_value unless in_reply_to_value.blank?
		mail.stub(:header) {header}
	end		

	def self.message_id(mail,message_id)
		mail.stub(:message_id) {message_id}
	end		

 	def self.subject(mail,subject)
    	mail.stub(:subject) {  StringExpander.expand_string subject }
	end

	def self.body(cucumber,mail,body)
	    mail_body = cucumber.double('body')
	    expanded_body = StringExpander.expand_string body 
		expanded_body = StringExpander.expand_email_body expanded_body 

	    mail_body.stub(:decoded) { expanded_body }  

	    mail_text_part = cucumber.double('text_part')
	    mail_text_part.stub(:body) { mail_body }

	    mail.stub(:multipart?) { true }
	    mail.stub(:text_part) { mail_text_part }
	end

end