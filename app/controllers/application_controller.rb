class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :store_location
  helper_method :current_user, :logged_in?
  before_action :set_top_hero_images

  private

  def store_location
    return unless request.get? || request.head?
    return if request.path.start_with?("/auth", "/admin")

    session[:return_to] = request.fullpath
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def set_top_hero_images
    @top_hero_images = PageImage.for_display(:top, :hero)
  end
end
