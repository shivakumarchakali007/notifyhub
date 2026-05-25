require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
    let!(:user) do
    User.create!(
      name: 'Shiva',
      email: 'shiva@example.com',
      password: 'password123'
    )
  end

  let(:token) do
    Auth::JwtEncoder.call(user_id: user.id)
  end

  describe "POST /api/v1/event" do
    let(:valid_params) do
      {
        event: {
          event_type: "commment_created",
          payload: {
            comment_id: 1,
            post_id: 10
          }
        }
      }
    end
    context "with valid token and params" do
      it "creates an event" do
        expect {
          post "/api/v1/event",
          params: valid_params,
          headers: {
            "Authorization" => "Bearer #{token}"
          }
        }.to change(Event, :count).by(1)
      end

      it "returns created status" do
        post "/api/v1/event",
        params: valid_params,
        headers: {
          "Authorization" => "Bearer #{token}"
        }
        expect(response).to have_http_status(:created)
      end

      it "creates event with proper data" do
        post '/api/v1/event',
        params: valid_params,
        headers: {
          "Authorization" => "Bearer #{token}"
        }
        expect(Event.last.event_type).to eq("commment_created")
        expect(Event.last.payload).to eq({ "comment_id"=>1, "post_id"=>10 })
        expect(Event.last.user_id).to eq(user.id)
      end
    end

    context "with invalid_params" do
      it "does nt create the event" do
        invalid_params = valid_params.deep_dup
        invalid_params[:event][:event_type] = nil
        expect {
          post '/api/v1/event',
          params: invalid_params,
          headers: {
            "Authorization" => "Bearer #{token}"
          }
        }.not_to change(Event, :count)
      end


      it "return unprocessable content status" do
        invalid_params = valid_params.deep_dup
        invalid_params[:event][:event_type] = nil
        post '/api/v1/event',
        params: invalid_params,
        headers: {
          "Authorization" => "Bearer #{token}"
        }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
