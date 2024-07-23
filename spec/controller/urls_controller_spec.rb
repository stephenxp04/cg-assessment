# spec/controllers/urls_controller_spec.rb
require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:user) { User.create!(cookie: SecureRandom.hex(10)) }
  
  before do
    cookies[:user_token] = user.cookie
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "creates a new Url" do
      expect {
        post :create, params: { url: { target_url: "https://example.com" } }
      }.to change(Url, :count).by(1)
    end

    it "creates a new ShortUrl" do
      expect {
        post :create, params: { url: { target_url: "https://example.com" } }
      }.to change(ShortUrl, :count).by(1)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested url" do
      url = user.urls.create!(target_url: "https://example.com", title: "Example")
      expect {
        delete :destroy, params: { id: url.id }
      }.to change(Url, :count).by(-1)
    end
  end
end