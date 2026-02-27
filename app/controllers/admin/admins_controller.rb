class Admin::AdminsController < Admin::BaseController
  def index
    @admins = Admin.order(created_at: :asc)
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to admin_admins_path, notice: "管理者を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    admin = Admin.find(params[:id])

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
