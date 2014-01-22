require 'spec_helper'

describe Event do

let(:installation) {
    @installation = FactoryGirl.create(:installation)
    @installation }	

before { @event = installation.events.build(event_type: "a"*20,note: "a"*999)}

  subject { @event }

  it { should respond_to(:event_type) }
  it { should respond_to(:note) }
  it { should respond_to(:installation_id) }
  it { should respond_to(:installation) }
  it { should respond_to(:created_at) }
  its(:installation) {should == installation}

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to installation_id" do
      expect do
        Event.new(installation_id: installation.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

 describe "when installation_id is not present" do
    before { @event.installation_id = nil }
    it { should_not be_valid }
  end

  describe "when note is too long" do
    before { @event.note = "a"*1001 }
    it { should_not be_valid }
  end




end
