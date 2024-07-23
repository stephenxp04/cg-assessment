# spec/services/url_shortener_service_spec.rb
require 'rails_helper'

RSpec.describe UrlShortenerService do
  describe "#shorten" do
    it "creates a short URL" do
      user = User.create!(cookie: SecureRandom.hex(10))
      url = user.urls.create!(target_url: "https://example.com", title: "Example")
      
      service = UrlShortenerService.new(url)
      short_url = service.shorten

      expect(short_url).to be_present
      expect(short_url.short_url).to be_present
    end
  end
end