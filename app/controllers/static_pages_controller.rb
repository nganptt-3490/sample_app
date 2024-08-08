class StaticPagesController < ApplicationController
  def home
    return false unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed, limit: Settings.pages.page_10
  end

  def help; end
end
