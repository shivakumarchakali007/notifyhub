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
      described_class.call(notification: notification)

      expect(notification.status).to eq("delivered")
    end
  end
end
