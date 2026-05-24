require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)

      expect(association.macro).to eq(:belongs_to)
    end
  end
  describe 'validations' do
    let(:user) do
      User.create!(
        name: 'Shiva',
        email: 'shiva@example.com',
        password: 'password123'
      )
    end

    subject do
      described_class.new(
        event_type: 'comment_created',
        payload: {
          comment_id: 1,
          post_id: 10
        },
        user: user
      )
    end

     it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without event_type' do
      subject.event_type = nil

      expect(subject).not_to be_valid
      expect(subject.errors[:event_type]).to include("can't be blank")
    end

    it 'is invalid without payload' do
      subject.payload = nil

      expect(subject).not_to be_valid
      expect(subject.errors[:payload]).to include("can't be blank")
    end

    it 'is invalid without a user' do
      subject.user = nil

      expect(subject).not_to be_valid
      expect(subject.errors[:user]).to include("must exist")
    end
  end
end
