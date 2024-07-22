# spec/system/url_shortener_spec.rb

require 'rails_helper'

RSpec.describe "URL Shortener", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "allows a user to shorten a URL" do
    visit root_path

    fill_in "url_target_url", with: "https://www.example.com"
    click_button "Shorten URL"

    expect(page).to have_content("Short URL created successfully!")
    expect(page).to have_content("https://www.example.com")
  end

  it "displays an error for invalid URLs" do
    visit root_path

    fill_in "url_target_url", with: "not a url"
    click_button "Shorten URL"

    expect(page).to have_content("Invalid URL")
  end

  it "allows a user to delete a shortened URL" do
    user = User.create!(cookie: SecureRandom.hex(10))
    url = user.urls.create!(title: 'Example', target_url: "https://www.example.com")
    short_url = url.short_urls.create!(short_url: SecureRandom.alphanumeric(15))
    
    visit root_path
    page.driver.browser.manage.add_cookie(name: 'user_token', value: user.cookie)
    visit root_path
  
    expect(page).to have_content("https://www.example.com")
    
    within "#url_#{url.id}" do
      # Click the "Delete" link
      click_link "Delete"
    end
  
    # Accept the confirmation dialog
    page.driver.browser.switch_to.alert.accept
  
    expect(page).not_to have_content("https://www.example.com")
  end

  it "allows a user to view usage report" do
    user = User.create!(cookie: SecureRandom.hex(10))
    url = user.urls.create!(target_url: "https://www.example.com", title: "Example")
    short_url = url.short_urls.create!(short_url: "abc123")
  
    Click.create!(
      short_url: short_url, 
      clicked_at: Time.current, 
      country: "US", 
      city: "New York",
      geolocation: "192.168.1.1",
      latitude: 40.7128,
      longitude: -74.0060
    )
  
    visit usage_report_path
    # Set the cookie using Capybara
    page.driver.browser.manage.add_cookie(name: 'user_token', value: user.cookie)
    # Refresh the page to apply the cookie
    visit usage_report_path
  
    select "abc123", from: "short_url_id"
    click_button "View Report"
  
    expect(page).to have_content("Report for Short URL: abc123")
    expect(page).to have_content("https://www.example.com")
    expect(page).to have_content("US")
    expect(page).to have_content("New York")
    expect(page).to have_content("192.168.1.1")
    expect(page).to have_content("40.7128")
    expect(page).to have_content("-74.006")
  end
end