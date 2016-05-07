class UsersController < ApplicationController

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
	puts "name===#{params[:name]}"
	puts "ems===#{params[:email]}"
	puts "pass===#{params[:password]}"
@user = User.new(user_params) 
if @user.save 
#UserMailer.registration_confirmation(@user).deliver
#session[:user_id] = @user.id 
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

def edit_pass
@user_pass = current_user
end

def update_password
@user_pass = User.find(current_user.id)
if @user_pass.update(user_params1)
# Sign in the user by passing validation in case their password changed
redirect_to '/new_recharge', :notice=>"Password changed Successfully"
else
render "edit_pass"
end
end


private
def user_params
params.require(:user).permit(:name, :role, :email, :password_digest, :password)
end

def user_params1
# NOTE: Using `strong_parameters` gem
params.require(:user).permit(:password, :password_confirmation)
end

end

