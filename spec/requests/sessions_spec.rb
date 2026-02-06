require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /auth/line/callback" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(provider: "line", uid: "U-test-uid-123")
    end

    it "LINEログインで user を作成し session に user_id を入れて戻り先へリダイレクトする" do
      # 戻り先を保存（store_location が動く前提）
      get new_reservation_path

      expect {
        get "/auth/line/callback", env: { "omniauth.auth" => auth_hash }
      }.to change(User, :count).by(1)

      user = User.last
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(new_reservation_path)
    end

    it "同じ provider+uid なら user を増やさない" do
      create(:user, :line_login, provider: "line", uid: "U-test-uid-123")

      expect {
        get "/auth/line/callback", env: { "omniauth.auth" => auth_hash }
      }.not_to change(User, :count)
    end
  end
end
