class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  before_action :require_public_application, only: %i[ new create ]
  before_action :require_admin,              only: :index
  before_action :require_own_user_or_admin,  except: %i[ index new create ]
  before_action :set_user,                   except: %i[ index new create ]

  layout -> { authenticated? && admin? ? "application" : "sessions" }, only: %i[ new create ]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(**user_params, role: "user", pfp: "medicine_kisser")

    if @user.save
      if authenticated? && admin?
        redirect_to @user, notice: t(".created_user")
      else
        start_new_session_for @user
        redirect_to root_path
      end
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
      redirect_to @user
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!

    unless @user.id == Current.user.id
      redirect_to users_path, notice: t(".deleted_this_weird_guy")
    else
      redirect_to landing_path, notice: t(".sorry_to_see_you_go")
    end
  end

  private
    def user_params
      params.expect(user: [ :email_address, :username, :password, :password_confirmation, :terms_of_service ])
    end

    def user_update_params
      allowed = [ :email_address, :username, :pfp, :language, :body_weight ]
      allowed << :role if admin?
      params.expect(user: allowed)
    end

    def require_own_user_or_admin
      if params[:id].to_i(10) != Current.user.id && !Current.user.admin?
        redirect_to root_path, alert: t(".unauthorized")
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_public_application
      unless EnvConfig::PUBLIC || (authenticated? && admin?)
        redirect_to root_path, alert: t(".private")
      end
    end
end
