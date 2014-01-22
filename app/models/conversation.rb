class Conversation < ActiveRecord::Base
  attr_accessible :responds_via, :external_message_id, :message_prefix,:display_as,:installation
  belongs_to :installation
  has_many  :messages , :order => 'created_at',:dependent => :destroy 


  validates :installation_id, presence: true

  def add_external_message(content, type)
    if(self.messages.size >= 10 )
      self.messages.first.delete
    end 
    self.messages.build(image_text: content,message_type: type,installation: self.installation) .save!
  end

  def add_reply content
    self.messages.build(image_text: content,message_type: Message::Type::REPLY,installation: self.installation).save!
  end

end
