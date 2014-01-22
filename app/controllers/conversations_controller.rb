  class ConversationsController < ApplicationController


  layout "messages", :only => [:messages]

  before_filter :find_conversation

  def messages 
    @conversation.installation.create_event Event::EventType::OK
    @event = @conversation.installation.events.build
  end  

  def reply 
    InstallationMailer.response_email(params["reply_text"].html_safe,@conversation).deliver
    @conversation.add_reply(params["reply_text"])
    flash[:success] = "Your response has been sent"
    redirect_to new_installation_event_path(@conversation.installation)
  end   


  private 
  def find_conversation
       @conversation = Conversation.find(params[:id]) if params[:id]
  end

end