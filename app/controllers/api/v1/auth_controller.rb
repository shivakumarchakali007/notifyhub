class Api::V1::AuthController < ApplicationController
  include Authenticatable

  skip_before_action :authenticate_user!, only: [ :signup, :login ]

  def signup
    user = User.new(user_params)
    if user.save
      render json: { success: true, data: { user: user } }, status: :created
    else
      render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_content
    end
  end


  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = Auth::JwtEncoder.call(user_id: user.id)

      render json: {
        success: true,
        token: token
      }, status: :ok
    else
      render json: {
        success: false,
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  def me
    render json: {
      success: true,
      user: current_user
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
