class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user_by_email
    if user_authenticated? user
      if user_activated? user
        handle_successful_login user
      else
        handle_unactivated_user
      end
    else
      handle_invalid_login
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  def find_user_by_email
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def user_authenticated? user
    user.try(:authenticate, params.dig(:session, :password))
  end

  def user_activated? user
    user.activated?
  end

  def handle_successful_login user
    log_in user
    remember_me user
    redirect_back_or user
  end

  def remember_me user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
  end

  def handle_unactivated_user
    flash[:warning] = t "account_active.not_activated"
    redirect_to root_url, status: :see_other
  end

  def handle_invalid_login
    flash.now[:danger] = t "auth.login.invalid_email_password_combination"
    render :new, status: :unprocessable_entity
  end
end
