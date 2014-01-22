require 'spec_helper'
include ActionDispatch::TestProcess

describe Message do

  before { 
    @message = Message.new
  }

  subject { @message }

  it { should respond_to(:photo) }
  it { should respond_to(:text) }
  it { should respond_to(:message_type) }
  it { should respond_to(:installation_id) }

  it {should be_valid }



  describe "when caption is too long" do
    it "should not be valid" do
    	@message.text = "a"*1001
        @message.photo =	File.new(Rails.root.join('features', 'upload-files', 'ImageIs2k.jpg')) 
    	should_not be_valid 
    end	

  end

end
