class ClicksController < ApplicationController
  def index
    @short_url = ShortUrl.find(params[:short_url_id])
    @clicks = @short_url.clicks
  end
end
