class Admin::SessionsController < ApplicationController
  def new
    session[:login_as] = "admin"
  end

  def destroy
    session.delete(:admin_uid)
    redirect_to root_path, notice: "管理者ログアウトしました"
  end
end