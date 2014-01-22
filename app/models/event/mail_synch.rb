class MailSynch 

	def self.check_email
		setup_defaults
		puts "this is the email auto-check working :) at " + Time.now.inspect
		Mail.all.each do |email|
			# only called if there is a new mail
            extracted_designation = (email.to.first.match /.*\+(.*)@.*/)[1]
		    installation_to_be_updated = Installation.find_by_designation extracted_designation
		    puts "mail found"
		    if installation_to_be_updated
		    	puts "adding mail to installation " + installation_to_be_updated.designation
				conversation_to_add_message_to = update_email_details(installation_to_be_updated,email )
				add_messages(conversation_to_add_message_to,email )
			else
				#where you would log if an email had no associated installation	
			end

		end
		
		emails = Mail.find(:what => :first, :count => 10, :order => :asc)
		# THIS IS PUTTING OUT 0! DOES THIS MEAN I HAVE TO CHANGE THE WHOLE MAIL SYSTEM?
		puts "This should be 10: " + emails.length.to_s

		ActiveRecord::Base.connection_pool.with_connection do
  			EventAnalyzer.createAlerts
		end
	end



    def self.add_messages(conversation,email)
		begin
			for_each_attachment_or_once_if_no_attachment(email) do | index , attachment|
				new_message = conversation.messages.build(installation: conversation.installation)
				add_photo_to_message(new_message,attachment) if attachment
				update_text(new_message,email )
        		new_message.message_type = determine_message_type(email,index)  
        		new_message.save 
        	end
		rescue 
    		puts "Unable to save photo for install because #{$!}"
		end
    end

    def self.for_each_attachment_or_once_if_no_attachment email

		if !email.attachments.nil? && !email.attachments.empty?
			# if the MIME type of the attachment contains "image" then yield each attachment with its index
			email.attachments.select {
				|attachment_to_check|
				puts "the MIME type of the attachment is: " + attachment_to_check.mime_type
				attachment_to_check.mime_type =~ /^image.*/
				} .each_with_index {|attachment,index| yield index,attachment}		 
		else
		   yield 0
		end
		
    end

    def self.determine_message_type email,index
    	if email.header['In-Reply-To']
    		Message::Type::EXTERNAL_REPLY
    	else
    		index == 0 ? Message::Type::EXTERNAL : Message::Type::EXTERNAL_ATTACHMENT 
    	end
    end

    def self.add_photo_to_message (message , attachment)
		file = StringIO.new(attachment.body.decoded)
		# here we are adding the following line of code to the file's class (stringIO):
		file.class.class_eval { attr_accessor :original_filename, :content_type }
		#now we have the accessor methods available for original_filename and content_type
		file.original_filename = attachment.filename
		file.content_type = attachment.mime_type
		# store the file in the message instance
		puts "we are adding photo to message"
		message.photo = file
		puts "done adding photo to message"
    end

	def self.update_text(new_message,email)
	    plain_part = email.multipart? ? (email.text_part ? email.text_part.body.decoded : nil) : email.body.decoded
        content = clean_up_body_content plain_part
		new_message.set_text(content , email.subject)
	end

	def self.update_email_details(installation_to_be_updated , email)
		existing_conversation = find_conversation_that_message_is_part_of(installation_to_be_updated,email)
		existing_conversation ||= installation_to_be_updated.conversations.build
		existing_conversation.message_prefix = Message.determine_raw_message_prefix(email.subject) if !email.subject.blank?
		existing_conversation.responds_via = email.from[0]
		existing_conversation.external_message_id = email.message_id
		existing_conversation.display_as = extract_display_as email.header['From'].to_s
		existing_conversation.save
		existing_conversation
	end	

	def self.find_conversation_that_message_is_part_of installation ,email
		return nil unless email.header['In-Reply-To']
		raw_subject = Message.determine_raw_message_prefix(email.subject)
		if raw_subject
        	installation.conversations.where("responds_via = ? AND message_prefix = ?",email.from[0],raw_subject).last
        else
        	installation.conversations.where("responds_via = ? AND message_prefix IS NULL",email.from[0]).last
        end		
	end

	def self.extract_display_as text
		if text =~ /(.*)\s*\<.*\>/
			$1.strip
		else
			text
		end		
	end

    def self.clean_up_body_content body_text
    	body_text = clean_up_forward_text body_text
    	clean_up_reply_text body_text
    end

    def self.clean_up_forward_text body_text
    	if body_text =~ /\- Forwarded message \-/
    		body_as_array = body_text.lines.to_a
    		index_of_wrote = body_as_array.index { | line | line =~ /\- Forwarded message \-/}
    		body_as_array = body_as_array.first(index_of_wrote)
    		body_text = body_as_array.join.strip
    	end
    	body_text

    end

    def self.clean_up_reply_text body_text
    	if body_text =~ /\<.*\>/
    		body_as_array = body_text.lines.to_a
    		index_of_wrote = body_as_array.index { | line | line =~ /\<.*\>/}
    		body_as_array = body_as_array.first(index_of_wrote)
    		body_text = body_as_array.join.strip
    	end
    	body_text
    end    

	def self.setup_defaults
		Mail.defaults do
		  retriever_method :pop3, :address    => "pop.gmail.com",
		                          :port       => 995,
		                          :user_name  => ENV['EMAIL_NAME'],
		                          :password   => ENV['EMAIL_PASSWORD'],
		                          :enable_ssl => true
		end
	end
end		