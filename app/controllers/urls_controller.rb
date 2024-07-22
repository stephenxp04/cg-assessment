require 'net/http'
require 'json'

class UrlsController < ApplicationController
  before_action :find_or_create_user
  before_action :set_url, only: [:destroy]

  def index
    @url = Url.new
    @urls = current_user.urls.includes(:short_urls)
  end

  def show
    short_url = ShortUrl.find_by(short_url: params[:id])
    
    if short_url
      ip = client_ipv4
      Rails.logger.info("IP Address: #{ip}")
      location = fetch_ipinfo(ip.split(',').first.strip)
  
      if location['bogon']
        Rails.logger.info("Bogon IP detected: #{ip}")
        country = "Unknown"
        city = "Unknown"
        latitude = 0.0
        longitude = 0.0
      else
        country = location['country'] || "Unknown"
        city = location['city'] || "Unknown"
        latitude = location['loc'].split(',')[0].to_f
        longitude = location['loc'].split(',')[1].to_f
      end
  
      Click.create(
        short_url: short_url,
        clicked_at: Time.current,
        geolocation: ip,
        country: country,
        city: city,
        latitude: latitude,
        longitude: longitude
      )
  
      url = short_url.url
  
      Rails.logger.info("Redirecting to: #{url.target_url}")
  
      begin
        uri = URI.parse(url.target_url)
        if uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
          redirect_to url.target_url, allow_other_host: true
        else
          Rails.logger.error("Invalid URL: #{url.target_url}")
          render plain: "Invalid URL", status: :unprocessable_entity
        end
      rescue URI::InvalidURIError => e
        Rails.logger.error("URI::InvalidURIError: #{e.message}")
        render plain: "Invalid URL", status: :unprocessable_entity
      end
    else
      render plain: "Not Found", status: :not_found
    end
  end

  def create
    @input = url_params[:target_url].strip
    unless @input =~ /\Ahttps?:\/\//
      @input = "https://" + @input
    end
    @url = current_user.urls.find_or_initialize_by(target_url: @input)
    if @url.new_record?
      if @url.save
        @url.update(title: fetch_title_from_url(@url.target_url))
      end
    end
    @shorturl = SecureRandom.alphanumeric(15)
    @short_url = @url.short_urls.create(short_url: @shorturl)
    @urls = current_user.urls.includes(:short_urls)
    @url1 = @url
    @url = Url.new

    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end
  
  def destroy
    @url = current_user.urls.find(params[:id])
  
    @url.short_urls.each do |short_url|
      short_url.clicks.destroy_all
    end
  
    @url.short_urls.destroy_all
    @url.destroy
  
    @urls = current_user.urls.includes(:short_urls)

    @url = Url.new

    respond_to do |format|
      format.turbo_stream
      format.html { render :index }
    end
  end

  def usage_report
    @urls = current_user.urls.includes(:short_urls)
    
    if params[:short_url_id].present?
      @selected_short_url = ShortUrl.find(params[:short_url_id])
      @clicks = @selected_short_url.clicks.order(clicked_at: :desc)
    else
      @clicks = []
    end
  end

  private

  def fetch_ipinfo(ip)
    token = ENV['GEOCODER_API_KEY']
    url = "http://ipinfo.io/#{ip}?token=#{token}"
    response = Net::HTTP.get(URI(url))
    JSON.parse(response)
  rescue StandardError => e
    Rails.logger.error("IPinfo API request failed: #{e.message}")
    {}
  end

  def find_or_create_user
    if cookies[:user_token].blank?
      Rails.logger.info("No user_token found in cookies. Creating a new user.")
      user = User.create(cookie: SecureRandom.hex(10))
      cookies[:user_token] = { value: user.cookie, expires: 1.year.from_now, secure: Rails.env.production? }
    else
      Rails.logger.info("user_token found in cookies: #{cookies[:user_token]}")
      user = User.find_by(cookie: cookies[:user_token])
      unless user
        Rails.logger.info("No user found with the given token. Creating a new user.")
        user = User.create(cookie: SecureRandom.hex(10))
        cookies[:user_token] = { value: user.cookie, expires: 1.year.from_now, secure: Rails.env.production? }
      end
    end
    @current_user = user
    Rails.logger.info("Current user set to: #{@current_user.id}")
  end

  def current_user
    @current_user
  end

  def set_url
    @url = current_user.urls.find(params[:id])
  end

  def url_params
    params.require(:url).permit(:target_url)
  end

  def fetch_title_from_url(url)
    return if url.blank?

    require "net/http"
    require "uri"
    require "nokogiri"

    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      document = Nokogiri::HTML(response.body)
      document.title
    else
      "No title found"
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch title: #{e.message}")
    "No title found"
  end
end
