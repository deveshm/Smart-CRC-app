require 'spec_helper'

describe Conversation do 

let(:installation) {  	
    @installation = FactoryGirl.create(:installation)
    @installation }	

before { @conversation = installation.conversations.build(external_message_id: "a"*20,responds_via: "a"*255,message_prefix: "a"*255)}


  subject { @conversation }

  it { should respond_to(:external_message_id) }
  it { should respond_to(:responds_via) }
  it { should respond_to(:message_prefix) }
  it { should respond_to(:installation_id) }
  it { should respond_to(:installation) }
  its(:installation) {should == installation}

end
