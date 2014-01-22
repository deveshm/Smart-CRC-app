class Message < ActiveRecord::Base

  attr_accessible :photo,:image_text,:last_display_in_carousel,:message_type,:interrupt,:installation
  attr_accessor :start_of_conversation

  belongs_to :conversation
  belongs_to :installation
  validates :image_text, length: { maximum: 1000 }

  # here we are telling paperclip to store the photo property as an attachment (default location is public/system etc.)
  has_attached_file :photo, :styles => { :original => "1050x700!", :thumb => "100x100>" }

  class Type
      REPLY = "reply"
      EXTERNAL = "external"
      EXTERNAL_REPLY = "external_reply"
      EXTERNAL_ATTACHMENT = "external_attachment"
  end  


  def retrive_url(request_url,style)
      #calling the amazing aws endpoint
      # sub = substitute function? url(:original) just gets the link to the image attachment
      recalibated_url = photo.url(style)
      # removed .sub('leanprojectbucket.s3.amazonaws.com','s3-ap-southeast-2.amazonaws.com')
      # puts "we have request_url: " + request_url
      # puts "we have recalibated_url: " + recalibated_url
      # joining the two urls and returning it
      URI.join(request_url, recalibated_url)
  end 


  def merge_image(request_url,image_to_overlay)
  	  underlay  = Magick::Image.from_blob(open(retrive_url(request_url,:original)).read).first
  	  overlay =   Magick::Image.from_blob(File.read(File.join(Rails.root, 'app','assets','images', image_to_overlay))).first
  	  overlay_over_underlay = underlay.composite(overlay, Magick::CenterGravity, 0, 0, Magick::OverCompositeOp) #the 0,0 is the x,y
      overlay_over_underlay.format = "jpeg"
      overlay_over_underlay_blob = overlay_over_underlay.to_blob
      overlay_over_underlay.destroy!
      overlay_over_underlay_blob
  end


  def safely_set_text text
      if text && text.length >= 1000
        self.image_text = text.slice(0,997) + "..."
      else
        self.image_text = text
      end  
  end  

  def caption
      if self.image_text && self.image_text.length >= 256
        self.image_text.slice(0,252) + "..."
      else
        self.image_text
      end  
  end    

  def photo_name_as_alphanumeric
    if start_of_conversation && !start_of_conversation.photo_file_name.blank?
      start_of_conversation.photo_file_name.gsub(/\W/,'')
    else
      photo_file_name.gsub(/\W/,'') 
    end

  end 

  def interrupt?
    self.interrupt
  end

  def has_photo?
    !self.photo_file_name.blank? ||  (start_of_conversation && !start_of_conversation.photo_file_name.blank? )
  end

  def set_text main_text, prefix_text
    content = nil
    if !prefix_text.blank? && !main_text.blank?
      content = "#{prefix_text} : #{main_text}"
    else
       content = "#{prefix_text}#{main_text}"
    end
    safely_set_text content
  end

  def calculate_message_prefix
    Message.determine_raw_message_prefix self.image_text
  end

  def self.determine_raw_message_prefix text_to_strip
    return nil unless text_to_strip
    text_to_strip.gsub(/Re\: /,'').partition(" : ")[0]  
  end



end
