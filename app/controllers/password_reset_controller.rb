class PasswordResetController < ApplicationController

#get
def forgot
end

#post
def reset_pass

	if params[:email] !=""
		@user=User.find_by_email(params[:email])
		@user.update(:password => params[:password])
		redirect_to '/login', notice: 'Password has been changed'
	elsif current_user !=nil
		@user = User.find(current_user.id)
		@user.update(:password => params[:password])
		redirect_to '/home', notice: 'Password has been changed'
	elsif params[:email] == "" and current_user == nil
		redirect_to '/password_reset', notice: 'Please enter the Email Id'
	end
end


end
