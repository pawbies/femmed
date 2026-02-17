class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  layout "sessions", only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      start_new_session_for @user
      redirect_to root_path
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def user_params
      params.expect(user: [:email_address, :username, :password, :password_confirmation])
    end
end
