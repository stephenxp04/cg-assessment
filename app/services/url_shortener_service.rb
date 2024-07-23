class UrlShortenerService
  def initialize(url)
    @url = url
  end

  def shorten
    short_url = generate_short_url
    @url.short_urls.create(short_url: short_url)
  end

  private

  def generate_short_url
    SecureRandom.alphanumeric(15)
  end
end