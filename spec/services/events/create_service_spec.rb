require "rails_helper"

RSpec.describe Events::CreateService do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let!(:user) do
    User.create!(
      name: "Shiva",
      email: "someemail@gmail.com",
      password: "pass"
    )
  end

  let(:params) do
    {
      event_type: "commented",
      payload: {
        post_id: 10,
        comment_id: 1
      }
    }
  end

  describe ".call" do
    it "creates an event" do
      expect { described_class.call(user: user, params: params) }.to change(Event, :count).by(1)
    end

    it "created with proper attributes" do
      event = described_class.call(user: user, params: params)

      expect(event.user).to eq(user)
      expect(event.event_type).to eq("commented")
      expect(event.payload).to eq({ "post_id" => 10, "comment_id" => 1 })
    end

    it "enques a job" do
      expect {
        described_class.call(user: user, params: params).to have_enqueued_job(ProcessEventJob)
      }
    end

    it "enqueues with proper event id" do
      event = described_class.call(user: user, params: params)
      expect(ProcessEventJob).to have_been_enqueued.with(event.id)
    end
  end
end
