class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    uid = session[:admin_uid]
    return if uid.present? && Admin.exists?(uid: uid)

    redirect_to admin_login_path, alert: "管理者ログインが必要です"
  end
end
