class Api::V1::EventsController < ApplicationController
  include Authenticatable

  def create
    event = Events::CreateService.call(
      user: current_user,
      params: event_params
    )

    render json: {
      success: true,
      event: event
    }, status: :created

  rescue ActiveRecord::RecordInvalid => e
    render json: {
      success: false,
      errors: e.record.errors.full_messages
    }, status: :unprocessable_content
  end

  private

  def event_params
    params.require(:event).permit(
      :event_type,
      payload: {}
    )
  end
end
