require 'spec_helper'

describe Notification do

  context "associations and attributes" do

    let(:receiver) { FactoryGirl.create(:user) }
    let(:sender) { FactoryGirl.create(:user) }
    let(:notification) { FactoryGirl.build(:message_notification, sender: sender, user: receiver) }

    subject { notification }

    context "attributes" do

      it { should respond_to(:user_id) }
      it { should respond_to(:sender_id) }
      it { should respond_to(:ntype) }
      it { should respond_to(:content) }
      it { should respond_to(:event_date) }
      it { should respond_to(:read) }
      it { should respond_to(:notificable_id) }
      it { should respond_to(:notificable_type) }

      it { should respond_to(:user) }
      it { should respond_to(:sender) }
      it { should respond_to(:notificable) }

      its(:user) { should == receiver }
      its(:sender) { should == sender }
    end

  end

  context "validations" do

    let(:notification) { FactoryGirl.build(:message_notification) }
    subject { notification }

    it { should be_valid }

    describe "when user_id is not present" do
      before { notification.user_id = nil }
      it { should_not be_valid }
    end

    describe "when sender_id is not present" do
      before { notification.sender_id = nil }
      it { should_not be_valid }
    end

    describe "with blank subject" do
      before { notification.ntype = " " }
      it { should_not be_valid }
    end


    describe "with ntype that is too long" do
      before { notification.ntype = "a" * 21 }
      it { should_not be_valid }
    end


    describe "with content that is too long" do
      before { notification.content = "a" * 501 }
      it { should_not be_valid }
    end

    describe "with valid types" do
      it "validates a welcome notification" do
        FactoryGirl.build(:welcome_notification).should be_valid
      end

      it "validates a message notification" do
        FactoryGirl.build(:message_notification).should be_valid
      end

      it "validates a feedback and feedback request notification" do
        FactoryGirl.build(:feedback_request_notification).should be_valid
        FactoryGirl.build(:feedback_notification).should be_valid
      end

      it "validates a friendship request and friendship approval" do
        FactoryGirl.build(:friendship_request_notification).should be_valid
        FactoryGirl.build(:friendship_approval_notification).should be_valid
      end
    end

    describe "with invalid type" do
      before { notification.ntype = "lala" }
      it { notification.should_not be_valid }
    end
  end


  describe "header feed" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      7.times { FactoryGirl.create(:feedback_notification, user: user) }
    end

    it "should contain the correct number of data points" do
      Notification.header(user).should have(5).items
    end
  end

  describe "unread scope" do

    let(:receiver) { FactoryGirl.create(:user) }
    before do
      3.times { FactoryGirl.create(:feedback_notification, user: receiver, read: false)  }
      5.times { FactoryGirl.create(:feedback_notification, user: receiver, read: true)  }
    end

    it "should only contain unread notifications (3 created and 1 welcome)" do
      receiver.notifications.unread.should have(4).items
    end

  end

  describe "url should be correct depending on ntype" do

    it "welcome" do
      notification = FactoryGirl.create(:welcome_notification)
      notification.url.should eql "http://localhost:3000/"
    end

    it "message" do
      notification = FactoryGirl.create(:message_notification)
      notification.url.should eql "http://localhost:3000/notifications/#{notification.id}"
    end

    it "feedback" do
      notification = FactoryGirl.create(:feedback_notification)
      notification.url.should eql "http://localhost:3000/cases/#{notification.notificable.id}"
    end

    it "feedback_req" do
      notification = FactoryGirl.create(:feedback_request_notification)
      notification.url.should eql "http://localhost:3000/cases/new"
    end

    it "friendship_req" do
      notification = FactoryGirl.create(:friendship_request_notification)
      notification.url.should eql "http://localhost:3000/friendships/#{notification.sender_id}"
    end

    it "friendship_app" do
      notification = FactoryGirl.create(:friendship_approval_notification)
      notification.url.should eql "http://localhost:3000/"
    end
  end
end