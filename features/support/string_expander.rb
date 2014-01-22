module StringExpander

 FOWARD_TEXT = <<-eos

---------- Forwarded message ----------
From: Caoilte Dunne <caoiltedunne@gmail.com>
Date: Thu, Feb 28, 2013 at 5:39 PM
Subject: This iz joels
To: apuhclean+conversationid@gmail.com



eos


 FOWARD_TEXT_WITH_NAME = <<-eos

---------- Forwarded message ----------
From: Caoilte Dunne <caoiltedunne@gmail.com>
Date: Thu, Feb 28, 2013 at 5:39 PM
Subject: This iz joels
To: apuhclean+conversationid@gmail.com <
apuhclean+conversationid@gmail.com>



eos

 REPLY_TEXT = <<-eos



On Wed, Mar 6, 2013 at 10:52 AM, <apuhclean@gmail.com> wrote:

    this is another message from the past

eos

 SECOND_REPLY_TEXT = <<-eos

2013/3/6 <apuhclean@gmail.com>

    Ok ok hold your horses

eos

 def self.expand_string(string_to_expand)
	  if string_to_expand =~ /a\*(\d+)/
	    	string_to_expand.gsub(/a\*(\d+)/) {|section_to_expand| "a"*$1.to_i if section_to_expand =~  /a\*(\d+)/ } 
	  else
	  		string_to_expand 
	  end
 end

 def self.expand_email_body(string_to_expand)
	  if string_to_expand =~ /\!forwarded\!/
		string_to_expand.gsub(/\!forwarded\!/,FOWARD_TEXT)
	  elsif string_to_expand =~ /\!forwarded_with_name\!/
		string_to_expand.gsub(/\!forwarded_with_name\!/,FOWARD_TEXT_WITH_NAME)
	  elsif string_to_expand =~ /\!reply\!/
		string_to_expand.gsub(/\!reply\!/,REPLY_TEXT)	  
	  elsif string_to_expand =~ /\!second_reply\!/
		string_to_expand.gsub(/\!second_reply\!/,SECOND_REPLY_TEXT)			
	  else 
		string_to_expand
	  end	

 end


end