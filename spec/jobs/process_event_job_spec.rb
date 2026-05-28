require 'rails_helper'

RSpec.describe ProcessEventJob, type: :job do
  let!(:user) do
    User.create!(
      name: 'Shiva',
      email: 'shiva@example.com',
      password: 'password123'
    )
  end

  let!(:event) do
    Event.create!(
      event_type: 'comment_created',
      payload: {
        comment_id: 1,
        post_id: 10
      },
      user: user
    )
  end

  describe '#perform' do
    context 'when event exists' do
      it 'creates a notification' do
        expect {
          described_class.perform_now(event.id)
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        described_class.perform_now(event.id)

        notification = Notification.last

        expect(notification.user).to eq(user)
        expect(notification.event).to eq(event)
        expect(notification.channel).to eq('in_app')
        expect(notification.status).to eq('delivered')
      end

      it 'delivers the notification' do
        described_class.perform_now(event.id)

        notification = Notification.last

        expect(notification.status).to eq('delivered')
      end
    end

    context 'when event does not exist' do
      it 'does not create notification' do
        expect {
          described_class.perform_now(99999)
        }.not_to change(Notification, :count)
      end

      it 'does not raise error' do
        expect {
          described_class.perform_now(99999)
        }.not_to raise_error
      end
    end

    context "when delivery fails" do
  let!(:failed_event) do
    Event.create!(
      event_type: "comment_created",
      payload: {
        comment_id: 1,
        post_id: 10,
        simulate_failure: true
      },
      user: user
    )
  end


  it "marks notification as failed" do
    begin
      described_class.perform_now(failed_event.id)
    rescue StandardError
    end

    notification = Notification.last

    expect(notification.status).to eq("failed")
  end
end
  end
end
