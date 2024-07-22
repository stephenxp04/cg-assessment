class ApplicationController < ActionController::Base
  before_action :log_request_info
  helper_method :client_ipv4

  private

  def client_ipv4
    forwarded_for = request.headers['X-Forwarded-For']
    if forwarded_for
      ip = forwarded_for.split(',').map(&:strip).find { |ip| ip =~ /\A(\d{1,3}\.){3}\d{1,3}\z/ }
      return ip if ip
    end
    request.remote_ip.to_s.split(':').last # In case of IPv6, get the last part
  end 

  def log_request_info
    Rails.logger.info "Remote IP: #{request.remote_ip}"
    Rails.logger.info "IPv4 Client IP: #{client_ipv4}"
    Rails.logger.info "X-Forwarded-For: #{request.headers['X-Forwarded-For']}"
    Rails.logger.info "Original Fullpath: #{request.original_fullpath}"
  end

end
