class Users::PasswordsController < Users::BaseController
  before_action :require_own_user

  def edit
  end

  def update
    p = password_params
    if @user.authenticate(p[:old_password])
      if @user.update(password: p[:password], password_confirmation: p[:password_confirmation])
        redirect_to @user, notice: "Updated your password"
      else
        redirect_back fallback_location: edit_user_password_path(@user), alert: t(".error", errors: @user.errors.full_messages.join(", "))
      end
    else
      redirect_back fallback_location: edit_user_password_path(@user), alert: t(".wrong_old_password")
    end
  end

  def password_params
    params.permit(:old_password, :password, :password_confirmation)
  end

  def require_own_user
    redirect_to root_path, alert: t(".you_cant_be_here") unless Current.user.id == @user.id
  end
end
