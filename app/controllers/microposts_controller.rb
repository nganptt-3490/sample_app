class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = build_micropost
    attach_image
    if save_micropost
      flash[:success] = t "microposts.create_success"
      redirect_to root_url
    else
      handle_failure
    end
  end

  def destroy
    if @micropost.destroy
      handle_destroy_success
    else
      flash[:danger] = t "microposts.delete_fail"
      redirect_to root_url
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.invalid"
    redirect_to request.referer || root_url
  end

  def handle_destroy_success
    current_page = extract_current_page_from_referer
    total_posts = current_user.feed.count
    total_pages = calculate_total_pages(total_posts)
    current_page = total_pages if current_page > total_pages
    flash[:success] = t "microposts.micropost_deleted"
    redirect_to root_url(page: current_page)
  end

  def extract_current_page_from_referer
    (URI(request.referer).query || "").split("&").find do |param|
      param.include?("page")
    end&.split("=")&.last&.to_i || 1
  end

  def calculate_total_pages total_posts
    (total_posts / Settings.pages.page_10.to_f).ceil
  end

  def build_micropost
    current_user.microposts.build(micropost_params)
  end

  def attach_image
    @micropost.image.attach(params.dig(:micropost, :image))
  end

  def save_micropost
    @micropost.save
  end

  def handle_failure
    @pagy, @feed_items = pagy(current_user.feed, limit: Settings.pages.page_10)
    render root_url, status: :unprocessable_entity
  end
end
