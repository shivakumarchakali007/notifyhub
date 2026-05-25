require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /api/v1/signup" do
    let(:valid_params) do
      {
        user: {
          name: "Shiva",
          email: "shivasome@example.com",
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
          email: "shivasome@example.com",
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

  describe "POST /api/v1/login" do
    let!(:user) do
      User.create!(
        name: 'Shiva',
        email: 'shiva1@example.com',
        password: 'password123'
      )
    end

    context "with valid credentials" do
      let(:valid_params) do
        {
          email: 'shiva1@example.com',
          password: 'password123'
        }
      end

      it "returns success reponse" do
        post "/api/v1/login", params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it "returns jwt token" do
        post "/api/v1/login", params: valid_params
        json = JSON.parse(response.body)
        expect(json['token']).to be_present
      end
    end

    context "with invalid credentials" do
      let(:invalid_params) do
        {
          email: 'shiva1@example.com',
          password: 'wrong_password'
        }
      end

      it "returns error response" do
        post "/api/v1/login", params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post "/api/v1/login", params: invalid_params
        json = JSON.parse(response.body)
        expect(json['success']).to eq(false)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end


  describe 'GET /api/v1/me' do
  let!(:user) do
    User.create!(
      name: 'Shiva',
      email: 'shivasome@example.com',
      password: 'password123'
    )
  end

  let(:token) do
    Auth::JwtEncoder.call(user_id: user.id)
  end

  context 'with valid token' do
    it 'returns current user' do
      get '/api/v1/me', headers: {
        'Authorization' => "Bearer #{token}"
      }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)

      expect(json['user']['email']).to eq(user.email)
    end
  end

  context 'without token' do
    it 'returns unauthorized status' do
      get '/api/v1/me'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with invalid token' do
    it 'returns unauthorized status' do
      get '/api/v1/me', headers: {
        'Authorization' => 'Bearer invalidtoken'
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
end
