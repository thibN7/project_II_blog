class SessionsController < ApplicationController

	def new
		if is_connected?
			redirect_to posts_path
		elsif !params['secret']
			redirect_to 'http://localhost:4567/sessions/new/appli_blog?origine=/sessions/new'
		elsif params['secret']=="iamsauth"
      session["current_user_blog"] = params['login']
	    redirect_to posts_path
		else
      redirect_to :root, :status => 403
		end
	end

	def destroy
		session["current_user_blog"] = nil
		redirect_to posts_path
	end


end
