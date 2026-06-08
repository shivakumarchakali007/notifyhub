require "rails_helper"
RSpec.describe "API::V1::Notifications", type: :request do
  let(:user) { User.create!(name: "Shiva", email: "[EMAIL_ADDRESS]", password: "password123") }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:notification) { Notification.create!(user: user, event: Event.create!(user: user, event_type: "test"), channel: "in_app", status: "delivered") }
  describe "GET /api/v1/notifications" do
    it "returns all notifications for the user" do
      get "/api/v1/notifications", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq("success" => true, "notifications" => Notification.where(user: user).as_json)
    end

    context "with invalid token" do
      it "returns error" do
        get "/api/v1/notifications", headers: { "Authorization" => "Bearer invalid" }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ "success" => false, "error" => "Unauthorized" })
      end
    end
  end
end
