class ApplicationController < ActionController::Base
  protect_from_forgery

	helper_method :is_connected?, :current_user, :must_be_connected

  def current_user
    return session["current_user_blog"]
  end

  def is_connected?
    !current_user.nil?
  end

	def must_be_connected
		unless is_connected?
			flash[:error] = "You must be logged in to access this section"
			redirect_to(new_session_path)
		end
  end

end
