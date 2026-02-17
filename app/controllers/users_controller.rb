class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :require_own_user, only: %i[ show edit update destroy ]
  before_action :fetch_user_by_id, only: %i[ show edit update destroy ]
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

  def show
  end

  def edit
  end

  def update
    if @user.update user_update_params
      redirect_to @user, notice: "Updated #{@user.username} ^^"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!

    redirect_to landing_path, notice: "Sorry to see you go"
  end

  private
    def user_params
      params.expect(user: [:email_address, :username, :password, :password_confirmation])
    end

    def user_update_params
      params.expect(user: [:email_address, :username])
    end

    def require_own_user
      if params[:id].to_i != Current.user.id
        redirect_to root_path, alert: "Hey! You can't be there!"
      end
    end

    def fetch_user_by_id
      @user = User.find(params[:id])
    end
end
