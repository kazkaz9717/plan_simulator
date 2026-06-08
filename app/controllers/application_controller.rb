class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: 'ログインしてください'
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: '管理者権限が必要です'
    end
  end

  helper_method :current_user, :logged_in?
end