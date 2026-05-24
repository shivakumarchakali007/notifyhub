class Api::V1::AuthController < ApplicationController
  def signup
    user = User.new(user_params)
    if user.save
      render json: { success: true, data: { user: user } }, status: :created
    else
      render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
