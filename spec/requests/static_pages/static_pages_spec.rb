require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /terms" do
    it "利用規約ページが表示される" do
      get terms_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("利用規約")
    end
  end

  describe "GET /privacy" do
    it "プライバシーポリシーページが表示される" do
      get privacy_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("プライバシーポリシー")
    end
  end

  describe "GET /contact" do
    it "お問い合わせページが表示される" do
      get contact_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("お問い合わせ")
    end
  end
end
