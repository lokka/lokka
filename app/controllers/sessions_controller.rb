class SessionsController < ApplicationController
  def new
    redirect_to admin_root_path if logged_in?
  end

  def create
    user = User.find_by(name: params[:name])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_root_path
    else
      flash.now[:alert] = 'Invalid username or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
