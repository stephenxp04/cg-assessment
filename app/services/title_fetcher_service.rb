require "net/http"
require "uri"
require "nokogiri"

class TitleFetcherService
  def self.fetch(url)
    return if url.blank?

    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      document = Nokogiri::HTML(response.body)
      document.title
    else
      ""
    end
  rescue StandardError => e
    Rails.logger.error("Failed to fetch title: #{e.message}")
    ""
  end
end