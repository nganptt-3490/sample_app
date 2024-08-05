class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
                only: %i(edit update)
  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_reset.check_email"
      redirect_to root_path
    else
      flash.now[:danger] = t "users.not_found_user"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("password_reset.password_blank")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "password_reset.change_pwd_success"
      redirect_to @user
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_PARAMS_PWD
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.not_found_user"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "account_active.not_activated"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset.expired"
    redirect_to new_password_reset_url
  end
end
