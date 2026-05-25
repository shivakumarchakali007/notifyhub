require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:user) do
    User.create!(
      name: 'Shiva',
      email: 'shiva1@example.com',
      password: 'password'
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

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to an event' do
      association = described_class.reflect_on_association(:event)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    subject do
      described_class.new(
        user: user,
        event: event,
        channel: 'email'
      )
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without user' do
      subject.user = nil

      expect(subject).not_to be_valid
    end

    it 'is invalid without event' do
      subject.event = nil

      expect(subject).not_to be_valid
    end

    it 'is invalid without channel' do
      subject.channel = nil

      expect(subject).not_to be_valid
    end

    it 'does not allow duplicate notification channel per user and event' do
      described_class.create!(
        user: user,
        event: event,
        channel: 'email'
      )

      duplicate = described_class.new(
        user: user,
        event: event,
        channel: 'email'
      )

      expect(duplicate).not_to be_valid
    end
  end

  describe 'defaults' do
    it 'has pending status by default' do
      notification = described_class.create!(
        user: user,
        event: event,
        channel: 'email'
      )

      expect(notification.status).to eq('pending')
    end
  end
end
