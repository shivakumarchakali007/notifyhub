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
    context "with valid params" do
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

    context "with invalid params" do
      it "does not create a new user" do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:email] = nil
        expect {
          post '/api/v1/signup', params: invalid_params
        }.to_not change(User, :count)
      end

      it "returns error response" do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:email] = nil
        post '/api/v1/signup', params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not allow duplicate email" do
        User.create!(
          name: "Existing User",
          email: "shiva@example.com",
          password: "password123"
        )
        expect {
          post '/api/v1/signup', params: valid_params
        }.to_not change(User, :count)
      end

      it 'returns error messages' do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:email] = nil

        post '/api/v1/signup', params: invalid_params

        json = JSON.parse(response.body)

        expect(json['success']).to eq(false)
        expect(json['errors']).to include("Email can't be blank")
      end
    end
  end
end
