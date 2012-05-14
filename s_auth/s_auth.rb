$: << File.join(File.dirname(__FILE__))

require 'sinatra'
require 'lib/user.rb'
require 'database.rb'
require 'logger'

use Rack::Session::Cookie, :key => 'rack.session.s_auth', :expire_after => 60*60*24*2, :secret => 'secret_s_auth'

set :logger , Logger.new('log/connections.txt', 'weekly')

#-----------------------
# HELPERS
#-----------------------
helpers do 

  def current_user
    session[:current_user]
  end

  def disconnect
    session[:current_user] = nil
  end

end

#-----------------------
# BEFORE
#-----------------------

before '/applications/new' do
	redirect '/sessions/new' if !current_user
end


#-----------------------
# INDEX PAGE
#-----------------------

#GET
get '/' do
	erb :"index"
end


#-----------------------
# USER REGISTRATION
#-----------------------

# GET 
get '/users/new' do
	erb :"users/new"
end

# POST
post '/users' do
	user = User.create('login' => params['login'], 'password' => params['password'])
	if user.valid?
		redirect '/sessions/new'
	else
		@registration_error = user.errors.messages
		erb :"users/new"
	end
end


#-----------------------
# USER AUTHENTICATION
#-----------------------

# GET 
get '/sessions/new' do
	erb :"sessions/new"
end

# POST
post '/sessions' do
	user = User.find_by_login(params['login'])
	if User.exists?(params['login'],params['password'])
		settings.logger.info("s_auth connection succeeded for the login " + params['login'])
		session[:current_user] = params['login']
		redirect '/'
	else
		settings.logger.info("s_auth connection failed for the login " + params['login'])
		if user.nil?
			@authentication_error = :unknown_user
		else
			@authentication_error = :match_password
		end
		@login = params['login']
		erb :"sessions/new"
	end
end


#------------------------
# DISCONNECTION
#------------------------

# GET
get '/sessions/disconnect' do
	settings.logger.info("s_auth disconnection succeeded for the login" + current_user)
	disconnect
	redirect '/'
end


#------------------------
# USER PAGES
#------------------------

# GET
get '/users/:login' do
	if current_user == params[:login]
		if current_user == "admin"
			@users = User.all
		end
		user = User.find_by_login(current_user)
		@applications = Application.where(:user_id => user.id)
		@utilizations = Utilization.where(:user_id => user.id)
		erb :"users/profil"
	else
		@error_forbidden = :current_user_match_login
		erb :"errors/forbidden"
	end
end


#------------------------
# USER SUPPRESSION
#------------------------
delete '/users/:login' do
	if current_user == "admin"
		user = User.find_by_login(params[:login])
		if user
			User.delete(user)
			redirect '/users/admin'
		else
			@error = :client_doesnt_exist
			erb :"errors/not_found"
		end
	else
		@error_forbidden = :user_not_admin
		erb :"errors/forbidden"
	end
end



#----------------------------
# APPLICATION REGISTRATION
#----------------------------

# GET NEW
get '/applications/new' do
	erb :"applications/new"
end

# POST
post '/applications' do
	user = User.find_by_login(current_user)
  appli = Application.create("name" => params['name'], "url" => params['url'], "user_id" => user.id)
	if appli.valid?
		redirect '/users/'+current_user
	else
		@registration_error = appli.errors.messages
		erb :"/applications/new"
	end
end

#GET DELETE
delete '/applications/:name' do
	if current_user
		appli = Application.find_by_name(params[:name])
		if !appli.nil?
			user = User.find_by_login(current_user)
			if user.id == appli.user_id
				Application.delete(appli)
				redirect '/users/'+current_user
			else
				@error_forbidden = :user_id_appli_user_id_match
				erb :"errors/forbidden"
			end
		else
			@error = :appli_doesnt_exist
			erb :"errors/not_found"
		end
	else
		@error_forbidden = :current_user_nil
		erb :"errors/forbidden"
	end
end


#------------------------------------
# CLIENT APPLICATION AUTHENTICATION
#------------------------------------

# GET 
get '/sessions/new/:appli' do
	if Application.exists?(params[:appli])
		if current_user
			if !Utilization.exists?(current_user, params[:appli])
				settings.logger.info("Utilization of the client application " + params[:appli] + " by the login " + current_user)
				Utilization.add(current_user, params[:appli])
			end
			settings.logger.info("Client application " + params[:appli] + " connection succeeded for the login " + current_user)
			redirection = Application.redirect(params[:appli], params[:origine], current_user) + '&secret=iamsauth'
			redirect redirection 
		else 
      @back_url = Application.back_url(params[:appli], params[:origine])
			erb :"sessions/new"
		end
	else
		@error = :appli_client_doesnt_exist
		erb :"errors/not_found"
	end
end

# POST
post '/sessions/:appli' do
	if User.exists?(params['login'], params['password'])
		session[:current_user] = params['login']
		if !Utilization.exists?(current_user, params[:appli])
			settings.logger.info("Utilization of the client application" + params[:appli] + " by the login " + current_user)
			Utilization.add(current_user, params[:appli])
		end
		settings.logger.info("Client application " + params[:appli] + " connection succeeded for the login " + current_user)
		redirect "#{params[:back_url]}?login=#{params['login']}&secret=iamsauth"
	else
		settings.logger.info("Client application " + params[:appli] + " connection failed for the login " + params['login'])
		user = User.find_by_login(params['login'])
		if user.nil?
			@authentication_error = :unknown_user
		else
			@authentication_error = :match_password
		end
		@back_url = params[:back_url]
		@login = params['login']
		erb :"sessions/new"
	end
end


# NOT FOUND
not_found do
  erb :"errors/not_found"
end




