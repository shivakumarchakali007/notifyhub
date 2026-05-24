require 'rails_helper'

RSpec.describe Auth::JwtDecoder do
  describe '.call' do
    it 'decodes token successfully' do
      token = Auth::JwtEncoder.call({ user_id: 1 })

      decoded_token = described_class.call(token)

      expect(decoded_token[:user_id]).to eq(1)
    end

    it 'returns nil for invalid token' do
      decoded_token = described_class.call('invalid_token')

      expect(decoded_token).to be_nil
    end
  end
end
