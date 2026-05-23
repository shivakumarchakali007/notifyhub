require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'validations' do
    subject(:user) do
      described_class.new(
        name: 'Shiva',
        email: 'shiva@example.com',
        password: 'password123'
      )
    end

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user.name = nil

      expect(user).not_to be_valid
    end

    it 'is invalid without an email' do
      user.email = nil

      expect(user).not_to be_valid
    end

    it 'is invalid with duplicate email' do
      user.save!

      duplicate_user = described_class.new(
        name: 'Another User',
        email: 'shiva@example.com',
        password: 'password123'
      )

      expect(duplicate_user).not_to be_valid
    end

    it 'is invalid without a password' do
      user.password = nil

      expect(user).not_to be_valid
    end
  end
end
