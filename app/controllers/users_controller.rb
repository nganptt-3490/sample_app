class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "users.not_found_user"
    redirect_to static_pages_home_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "auth.signup.signup_success"
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTE_PERMITTED
  end
end
