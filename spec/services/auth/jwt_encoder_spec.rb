require 'rails_helper'

RSpec.describe Auth::JwtEncoder do
  describe '.call' do
    it 'returns encoded jwt token' do
      token = described_class.call({ user_id: 1 })

      expect(token).to be_a(String)
    end
  end
end
