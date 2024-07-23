# spec/models/url_spec.rb
require 'rails_helper'

RSpec.describe Url, type: :model do
  it "is valid with valid attributes" do
    user = User.create!(cookie: SecureRandom.hex(10))
    url = Url.new(target_url: "https://example.com", title: "Example", user: user)
    expect(url).to be_valid
  end

  it "is not valid without a target_url" do
    url = Url.new(title: "Example")
    expect(url).to_not be_valid
  end

  it "is not valid with an invalid target_url format" do
    url = Url.new(target_url: "not_a_url", title: "Example")
    expect(url).to_not be_valid
  end

  it "creates a short_url after creation" do
    user = User.create!(cookie: SecureRandom.hex(10))
    url = Url.create!(target_url: "https://example.com", title: "Example", user: user)
    short_url = SecureRandom.alphanumeric(15)
    url.short_urls.create(short_url: short_url)
    expect(url.short_urls).to_not be_empty
  end
end