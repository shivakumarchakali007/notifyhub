require "rails_helper"

RSpec.describe Notifications::DeliveryService do
  let!(:user) do
    User.create!(
      name: "Shiva",
      email: "someemail@gmail.com",
      password: "password123"
    )
  end
  let!(:event) do
    Event.create!(
      event_type: "comment_created",
      payload: { comment_id: 1, post_id: 10 },
      user: user
    )
  end
  let(:notification) do
    Notification.create!(
      status: "pending",
      event: event,
      user: user,
      channel: "in_app"
    )
  end

  describe ".call" do
    it "updates the status to delivered" do
      expect {
        described_class.call(notification: notification)
      }.to change(notification, :status).from("pending").to("delivered")
    end

    context "it fails to update" do
      before do
        allow(notification)
          .to receive(:update!)
          .with(status: "delivered")
          .and_raise(StandardError)

        allow(notification)
          .to receive(:update!)
          .with(status: "failed")
          .and_return(true)
      end

      it "updates the status to failed" do
        described_class.call(notification: notification)

        expect(notification)
          .to have_received(:update!)
          .with(status: "failed")
      end
    end
  end
end
