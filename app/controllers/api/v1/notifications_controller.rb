class Api::V1::NotificationsController < ApplicationController
  include Authenticatable
  include Notifications
  def index
    notifications = FetchService.call(user: current_user)
    render json: { success: true, notifications: notifications }
  end
end
