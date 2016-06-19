class UsersController < ApplicationController

  def tango
  end
 
  def tango_post
  if params[:pass] == "echocharlee"
  @adminuser = User.new(:name=>params[:name], :role=>params[:role], :email=>params[:email], :password =>params[:password])
  @adminuser.save  
  redirect_to '/login' 
  else 
  redirect_to '/admin_signup' 
  end 
  end

def new
@user = User.new
end

def index
require_dev_or_admin
@users=User.all
end


def destroy
@user=User.find(params[:id])
@user.destroy
redirect_to '/users'
end

def create 
@user = User.new(user_params) 
if @user.save 
redirect_to '/login' 
else 
redirect_to '/signup' 
end 
end

def edit
end

# PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    respond_to do |format|
      if User.find(params[:id]).update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end


def delete_users
  User.delete_all
  redirect_to '/'
end


private
def user_params
params.require(:user).permit(:name, :role, :email, :password)
end

def user_params1
# NOTE: Using `strong_parameters` gem
params.require(:user).permit(:password, :password_confirmation)
end

end

