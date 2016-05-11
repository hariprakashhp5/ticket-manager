class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :pending
	helper_method :current_user 


	def current_user 
  @current_user ||= User.find(session[:user_id]) if session[:user_id] 
end

def require_user 
  redirect_to '/login' unless current_user 
end

def require_editor 
  redirect_to '/login' unless current_user.editor? 
end

def require_dev
  redirect_to '/login' unless current_user.dev? 
end


def require_admin 
  if current_user != nil
  redirect_to '/login' unless current_user.admin? 
else
  redirect_to '/login'
end
end

def require_qc_or_admin_or_dev
  if current_user != nil
  redirect_to '/login' unless current_user.admin? || current_user.qc? || current_user.dev?
else
  redirect_to '/login'
end
end

def require_dev_or_admin
  if current_user !=nil
    redirect_to '/login' unless current_user.admin? || current_user.dev?
  else
    redirect_to '/login'
  end
end


def user
  if current_user !=nil
    @@user=current_user.id 
  #else
    #redirect_to '/login'
  end

end

 def pending
    @pendings=Tracker.where("uid=? and finished=?", user,"")
    @p_count=@pendings.count
    return @p_count
end

def search
	@res=Tracker.where("ticket_id LIKE ?", "%#{params[:ticket_id]}%")
end




end
