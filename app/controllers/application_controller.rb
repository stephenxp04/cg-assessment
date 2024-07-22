class ApplicationController < ActionController::Base
  before_action :log_request_info

  private

  def log_request_info
    Rails.logger.info "Remote IP: #{request.remote_ip}"
    Rails.logger.info "X-Forwarded-For: #{request.headers['X-Forwarded-For']}"
    Rails.logger.info "Original Fullpath: #{request.original_fullpath}"
  end

end
