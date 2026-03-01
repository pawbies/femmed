class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  before_action :require_public_application, only: %i[ new create ]
  before_action :require_admin,              only: :index
  before_action :require_own_user_or_admin,  except: %i[ index new create ]
  before_action :set_user,                   except: %i[ index new create ]

  layout "sessions", only: %i[ new create ]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(**user_params, role: "user", pfp: "medicine_kisser")

    if @user.save
      start_new_session_for @user
      redirect_to root_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def profile
    redirect_to Current.user
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

    unless Current.user.admin?
      redirect_to landing_path, notice: "Sorry to see you go"
    else
      redirect_to users_path, notice: "Deleted this weird guy >:3"
    end
  end

  private
    def user_params
      params.expect(user: [ :email_address, :username, :password, :password_confirmation, :terms_of_service ])
    end

    def user_update_params
      params.expect(user: [ :email_address, :username, :pfp ])
    end

    def require_admin
      unless Current.user.role == "admin"
        redirect_to root_path, alert: "Go away!!!"
      end
    end

    def require_own_user_or_admin
      if params[:id].to_i != Current.user.id && Current.user.role != "admin"
        redirect_to root_path, alert: "Hey! You can't be there!"
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_public_application
      unless EnvConfig::PUBLIC
        redirect_to root_path, alert: "UwU... whatcha doin there ^^"
      end
    end
end
