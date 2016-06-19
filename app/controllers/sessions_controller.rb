class SessionsController < ApplicationController


def new
  if current_user !=nil
    redirect_to '/home'
  end
end


def create
  @user = User.find_by_email(params[:session][:email])
  if @user && @user.authenticate(params[:session][:password])
    session[:user_id] = @user.id
    redirect_to '/home'#, :notice => "Logged in!"
  else
    flash.now.alert = "Invalid email or password"
    redirect_to '/login'
  end
end


def destroy 
  session[:user_id] = nil 
  redirect_to '/login' 
end
end
