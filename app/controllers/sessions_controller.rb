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
    redirect_to '/home', notice: "Logged in!"
  else
    redirect_to '/login', notice: 'Invalid email or password'
  end
end


def destroy 
  session[:user_id] = nil 
  redirect_to '/login' 
end
end
