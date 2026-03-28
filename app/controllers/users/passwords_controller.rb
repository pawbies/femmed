class Users::PasswordsController < Users::BaseController
  before_action :require_own_user

  def edit
  end
  def update
    if @user.authenticate(params[:old_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        redirect_to @user, notice: "Updated your password"
      else
        redirect_back fallback_location: edit_user_password_path(@user), alert: t(".error", errors: @user.errors.full_messages.join(", "))
      end
    else
      redirect_back fallback_location: edit_user_password_path(@user), alert: t(".wrong_old_password")
    end
  end

  def require_own_user
    redirect_to root_path, alert: t(".you_cant_be_here") unless Current.user.id == @user.id
  end
end
