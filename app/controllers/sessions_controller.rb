class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'ユーザー名またはパスワードが違います'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: 'ログアウトしました'
  end

  def guest_login
    guest = User.find_by(name: 'guest')
    session[:user_id] = guest.id
    redirect_to root_path, notice: 'ゲストとしてログインしました'
  end
end