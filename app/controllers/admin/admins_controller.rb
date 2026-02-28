class Admin::AdminsController < Admin::BaseController
  def index
    @admins = Admin.includes(:user).order(created_at: :asc)
    @current_admin = Admin.includes(:user).find_by(uid: session[:admin_uid])
  end

  def create
    uid = admin_params[:uid].to_s.strip

    user = User.find_by(provider: "line", uid: uid)
    unless user
      redirect_to admin_users_path, alert: "ユーザーが見つかりません（先にLINEログインしてもらってください）"
      return
    end

    if Admin.exists?(uid: uid)
      redirect_to admin_admins_path, alert: "すでに管理者として登録されています"
      return
    end

    admin = Admin.new(uid: uid, user: user)

    if admin.save
      redirect_to admin_admins_path, notice: "管理者を追加しました"
    else
      redirect_to admin_admins_path, alert: admin.errors.full_messages.first
    end
  end

  def destroy
    admin = Admin.find_by!(id: params[:id])

    # ✅ 自分自身は削除できない（事故防止）
    if admin.uid == session[:admin_uid]
      redirect_to admin_admins_path, alert: "自分自身は削除できません"
      return
    end

    # ✅ 最後の管理者は削除できない（事故防止）
    if Admin.count <= 1
      redirect_to admin_admins_path, alert: "最後の管理者は削除できません"
      return
    end

    admin.destroy
    redirect_to admin_admins_path, notice: "管理者を削除しました"
  end

  private

  def admin_params
    params.require(:admin).permit(:uid)
  end
end
