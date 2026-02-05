class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    auth = request.env['omniauth.auth']

    user = User.find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    )

    session[:user_id] = user.id
    redirect_to(session.delete(:return_to) || root_path)
  end
end