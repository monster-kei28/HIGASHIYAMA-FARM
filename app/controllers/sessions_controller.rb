class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    auth = request.env["omniauth.auth"]
    uid  = auth.uid

    # ✅ 管理者ログイン
    if session.delete(:login_as) == "admin"
      unless Admin.exists?(uid: uid)
        redirect_to root_path, alert: "管理者として認証できませんでした"
        return
      end

      session[:admin_uid] = uid
      redirect_to admin_reservations_path, notice: "管理者としてログインしました"
      return
    end

    # ✅ 一般ユーザー（既存のまま）
    user = User.find_or_create_by(provider: auth.provider, uid: uid)
    session[:user_id] = user.id
    flash[:notice] = "LINEでログインしました"
    redirect_to(session.delete(:return_to) || root_path)
  end
end
