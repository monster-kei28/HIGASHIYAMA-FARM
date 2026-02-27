class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(provider: "line").order(created_at: :desc)
    @admin_user_ids = Admin.where.not(user_id: nil).pluck(:user_id).to_set
  end
end