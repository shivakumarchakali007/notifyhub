require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /api/v1/signup" do
    let(:valid_params) do
      {
        user: {
          name: "Shiva",
          email: "shiva@example.com",
          password: "passwodr123"
        }
      }
    end
    it "creates a new user" do
      expect {
        post '/api/v1/signup', params: valid_params
      }.to change(User, :count).by(1)
    end

    it "returns seccess response" do
      post '/api/v1/signup', params: valid_params
      expect(response).to have_http_status(:created)
    end
  end
end
