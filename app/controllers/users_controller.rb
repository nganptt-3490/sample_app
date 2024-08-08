class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sorted, limit: Settings.pages.page_10
  end

  def show
    @pagy, @microposts = pagy @user.microposts, limit: Settings.pages.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "account_active.check_email"
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "noti.update_success"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "noti.delete_success"
    else
      flash[:danger] = t "noti.delete_fail"
    end
    redirect_to users_url
  end

  def following
    @title = t "follow.following"
    @pagy, @users = pagy(@user.following, limit: Settings.pages.page_10)
    render :show_follow
  end

  def followers
    @title = t "follow.follower"
    @pagy, @users = pagy(@user.followers, limit: Settings.pages.page_10)
    render :show_follow
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTE_PERMITTED
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.not_found_user"
    redirect_to root_url
  end

  def correct_user
    return if current_user? @user

    flash[:error] = t "errors.you_cannot_edit_this_account"
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
