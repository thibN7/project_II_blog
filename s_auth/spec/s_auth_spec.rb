require_relative 'spec_helper'

require '../s_auth'
require 'rack/test'

describe "Application" do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

	#-----------------------
	# INDEX PAGE
	#-----------------------
	describe "Index page" do

		describe "get /" do

			it "should get /" do
				get '/'
				last_response.should be_ok
				last_request.path.should == '/'
			end

			it "should return a form to post index page" do
				get '/'
				last_response.body.should match %r{<title>Index</title>.*}
			end

		end

	end


	#-----------------------
	# USER REGISTRATION
	#-----------------------
	describe "User registration" do

		# GET
		describe "get /users/new" do

			it "should get /users/new" do
				get '/users/new'
				last_response.should be_ok
				last_request.path.should == '/users/new'
			end

			it "should return a form to post user registration info" do
				get '/users/new'
				last_response.should be_ok
				last_response.body.should match %r{<form.*action="/users".*method="post".*}
			end

		end

		# POST
		describe "post /users" do

			before(:each) do
				@params = {'login' => 'tmorisse','password' => 'passwordThib'}
				@user = double(User)
				User.stub(:create){@user}
			end

			it "should use create method" do
				User.should_receive(:create).with(@params)
				post '/users', @params
			end

			describe "Registration ok" do

				before(:each) do
					@user.stub(:valid?){true}
					@user.stub(:login){"tmorisse"}
				end

				it "should redirect to sessions/new" do
					post '/users', @params
					last_response.should be_redirect
					follow_redirect!
					last_request.path.should == '/sessions/new'
				end

			end

			describe "Registration not ok" do

				before(:each) do
					@errors = double("Errors")
					@user.stub(:errors).and_return(@errors)
					@messages = double("Messages")
					@errors.stub(:messages).and_return(@messages)
					@messages.stub(:each)
					@user.stub(:valid?){false}
				end

				it "should rerender the registration form" do
					post '/users', @params
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/users".*method="post".*}
				end

			end

		end

	end
	# END USER REGISTRATION

	#--------------------------------------------------------------------

	#------------------------
	# USER AUTHENTICATION
	#------------------------
	describe "User authentication" do

		# GET
		describe "get /sessions/new" do

			it "should get /sessions/new" do
				get '/sessions/new'
				last_response.should be_ok
				last_request.path.should == '/sessions/new'
			end

			it "should return a form to post authentication info" do
				get '/sessions/new'
				last_response.should be_ok
				last_response.body.should match %r{<form.*action="/sessions".*method="post".*}
			end

		end

		# POST
		describe "post /sessions" do

			before(:each) do
				@params = {'login' => 'tmorisse','password' => 'passwordThib'}
				@user = double(User)
				User.stub(:find_by_login){@user}
			end

			it "should use the find_by_login method" do
				User.should_receive(:find_by_login).with('tmorisse')
				post '/sessions', @params
			end

			# Authentication ok
			describe "Authentication ok" do

				before(:each) do
					User.stub(:exists?){true}
				end

				it "should use the exists? method" do
					User.should_receive(:exists?).with('tmorisse', 'passwordThib')
					post '/sessions', @params
				end

				it "should create a session (define a cookie)" do
					post '/sessions', @params
					last_request.env["rack.session"][:current_user].should == "tmorisse"
				end

				it "should redirect the user to the index page" do
					post '/sessions', @params
					last_response.should be_redirect
					follow_redirect!
					last_request.path.should == '/'
				end

			end

			# Authentication not ok
			describe "Authentication not ok" do

				before(:each) do
					User.stub(:exists?){false}
				end

				it "should use the exists? method" do
					User.should_receive(:exists?).with('tmorisse', 'passwordThib')
					post '/sessions', @params
				end

				it "should rerender the form if the user is unknown" do
					@user.stub(:nil?).and_return(true)
					post '/sessions', @params
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/sessions".*method="post".*}
				end

				it "should rerender the form if the password is wrong" do
					@user.stub(:nil?).and_return(false)
					post '/sessions', @params
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/sessions".*method="post".*}
				end

			end

		end

	end
	# END USER AUTHENTICATION

	#----------------------------------------------------------------

	#-------------------------
	# USER DISCONNECTION
	#-------------------------
	describe "User disconnection" do

		before(:each) do
			@session = { "rack.session" => { :current_user => "tmorisse" } }
			get '/sessions/disconnect', {}, @session
		end

		it "should disconnect the user by cleaning the session" do
			last_request.env["rack.session"][:current_user].should be_nil
		end

		it "should redirect to the index page" do
			last_response.should be_redirect
			follow_redirect!
			last_request.path.should == '/'
		end

	end
	# END USER DISCONNECTION

	#----------------------------------------------------------------

	#-------------------------
	# USER PAGES
	#-------------------------
	describe "User pages" do

		describe "get /users/:login" do

			before(:each) do
				@session = { "rack.session" => { :current_user => "tmorisse" } }
			end

			it "should get /users/tmorisse" do
				get '/users/tmorisse'
				last_response.should be_ok
				last_request.path.should == '/users/tmorisse'
			end

			describe "The login and the current_user are the same" do

				before(:each) do
					@user = double(User)
					@appli = double(Application)
					@util = double(Utilization)
					User.stub(:all)
					User.stub(:find_by_login){@user}
					@user.stub(:id){12}					
					Application.stub(:where){@appli}
					@appli.stub(:empty?){true}
					@appli.stub(:each)
					Utilization.stub(:where){@util}
					@util.stub(:empty?){true}
				end

				describe "The current_user is the admin" do

					it "should use the 'all' method from User class" do
						@session = { "rack.session" => { :current_user => "admin" } }
						User.should_receive(:all)
						get '/users/admin', {}, @session
					end

				end

				it "should use find_by_login method from User class" do
					User.should_receive(:find_by_login).with('tmorisse')
					get '/users/tmorisse', {}, @session
				end

				it "should use where method from Application class" do
					Application.should_receive(:where).with(:user_id => 12)
					get '/users/tmorisse', {}, @session
				end

				it "should use where method from Application class" do
					Utilization.should_receive(:where).with(:user_id => 12)
					get '/users/tmorisse', {}, @session
				end

				it "should render the user page" do
					get '/users/tmorisse', {}, @session
					last_response.body.should match %r{<title>User Profile</title>.*}
				end

			end

			describe "The login and the current_user are not the same" do

				it "should return the user to the forbidden page" do
					get '/users/toto', {}, @session
					last_response.should be_ok
					last_response.body.should match %r{<title>Forbidden</title>.*}
				end

			end

		end

	end
	# END USER PAGES


	#-------------------------
	# USER SUPPRESSION
	#-------------------------
	describe "User suppression" do

		describe "delete /users/:login" do

			describe "The current_user is the admin" do

				before(:each) do
					@user = double(User)
					User.stub(:find_by_login)
					@session = { "rack.session" => { :current_user => "admin" } }
				end

				it "should exists a current_user (session)" do
					delete '/users/tmorisse', {}, @session
					last_request.env["rack.session"][:current_user].should == "admin"
				end

				it "should use find_by_login method from User class" do
					User.should_receive(:find_by_login).with('tmorisse')
					delete '/users/tmorisse', {}, @session
				end

				describe "The user to delete exists" do

					before(:each) do
						User.stub(:find_by_login){@user}
						User.stub(:delete){@user}
					end

					it "should delete the user, all the applications he has created, and the list of the utilizations of applications" do
						User.should_receive(:delete).with(@user)
						delete '/users/tmorisse', {}, @session
					end

					it "should redirect to the admin profile page" do
						delete '/users/tmorisse', {}, @session
						last_response.should be_redirect
						follow_redirect!
						last_request.path.should == '/users/admin'
					end

				end

				describe "The user to delete doesn't exist" do

					it "should return the admin to the not_found page" do
						User.stub(:find_by_login){nil}
						delete '/users/tmorisse', {}, @session
						last_response.should be_ok
						last_response.body.should match %r{<title>Not found</title>.*}
					end

				end

			end

			describe "The current_user is not the admin" do

				it "should return the current_user to the forbidden page" do
					@session = { "rack.session" => { :current_user => "tmorisse" } }
					delete '/users/tmorisse', {}, @session
					last_response.should be_ok
					last_response.body.should match %r{<title>Forbidden</title>.*}
				end

			end

		end

	end


	#-------------------------
	# APPLICATION REGISTRATION
	#-------------------------
	describe "Application Registration" do

		# GET /APPLICATIONS/NEW
		describe "get /applications/new" do

			describe "The current_user exists" do

				before(:each) do
					@session = { "rack.session" => { :current_user => "tmorisse" } }
				end

				it "should get /applications/new" do
					get '/applications/new', {}, @session
					last_response.should be_ok
					last_request.path.should == '/applications/new'
				end

				it "should return a form to post applications info" do
					get '/applications/new', {}, @session
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/applications".*method="post".*}
				end

			end

			describe "The current_user doesn't exist" do

				it "should redirect the user to the forbidden page" do
					get '/applications/new'
					last_response.should be_redirect
					follow_redirect!
					last_request.path.should == '/sessions/new'
				end

			end

		end

		# POST /APPLICATIONS
		describe "post /applications" do

			before(:each) do
				@paramsAppli = {"name" => "nomAppli","url" => "http://urlAppli.fr"}
				@paramsAppli1 = {"name" => "nomAppli","url" => "http://urlAppli.fr","user_id" => 12}
				@session = { "rack.session" => { :current_user => "tmorisse" } }
				@user = double(User)
				@appli = double(Application)
				User.stub(:find_by_login){@user}
				@user.stub(:id){12}
				Application.stub(:create){@appli}
			end

			it "should exist a current_user" do
				post '/applications', @paramsAppli, @session
				last_request.env["rack.session"][:current_user].should == "tmorisse"
			end

			it "should use find_by_login method from User class" do
				User.should_receive(:find_by_login).with('tmorisse')
				post '/applications', @paramsAppli, @session
			end

			it "should use create method from Application class" do
				Application.should_receive(:create).with("name"=>"nomAppli", "url"=>"http://urlAppli.fr", "user_id"=>12)
				post '/applications', @paramsAppli, @session
			end

			describe "Registration ok" do
		
				it "should use valid? method from @appli object" do
					@appli.should_receive(:valid?)
					post '/applications', @paramsAppli, @session
				end

				it "should redirect to the user page /users/:login" do
					@appli.stub(:valid?){true}
					post '/applications', @paramsAppli, @session
					last_response.should be_redirect
					follow_redirect!
					last_request.path.should == '/users/tmorisse'
				end

			end

			describe "Registration not ok" do

				before(:each) do
					Application.stub(:create){@appli}
					@errors = double("Errors")
					@appli.stub(:errors).and_return(@errors)
					@messages = double("Messages")
					@errors.stub(:messages).and_return(@messages)
					@messages.stub(:each)
				end

				it "should use valid? method from @appli object" do
					@appli.should_receive(:valid?)
					post '/applications', @paramsAppli, @session
				end

				it "should rerender the form" do
					@appli.stub(:valid?){false}
					post '/applications', @paramsAppli, @session
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/applications".*method="post".*}
				end

			end

		end

		# GET APPLICATION/DELETE
		describe "delete /application/:name" do

			describe "The current_user exists" do

				before(:each) do
					@session = { "rack.session" => { :current_user => "tmorisse" } }
					@appli = double(Application)
					@user = double(User)
					Application.stub(:find_by_name){@appli}
				end

				it "should exist a current_user (session)" do
					delete '/applications/appliTest', {}, @session
					last_request.env["rack.session"][:current_user].should == "tmorisse"
				end

				it "should use find_by_name method from Application class" do
					Application.should_receive(:find_by_name).with("appliTest")
					delete '/applications/appliTest', {}, @session
				end

				describe "The application exists" do

					before(:each) do
						@appli.stub(:nil?){false}
						User.stub(:find_by_login){@user}
					end

					it "should use find_by_login method from User class" do
						User.should_receive(:find_by_login).with("tmorisse")
						delete '/applications/appliTest', {}, @session
					end

					describe "The current_user and the application owner are the same" do

						before(:each) do
							@appli.stub(:user_id){12}
							@user.stub(:id){12}
							Application.stub(:delete)
						end

						it "should use delete method from Application class" do
							Application.should_receive(:delete).with(@appli)
							delete '/applications/appliTest', {}, @session
						end

						it "should redirect to the user page" do
							delete '/applications/appliTest', {}, @session
							last_response.should be_redirect
							follow_redirect!
							last_request.path.should == '/users/tmorisse'
						end

					end

					describe "The current_user and the application owner are not the same" do

						it "should return the user to the forbidden page" do
							@appli.stub(:user_id){12}
							@user.stub(:id){33}
							delete '/applications/appliTest', {}, @session
							last_response.should be_ok
							last_response.body.should match %r{<title>Forbidden</title>.*}
						end

					end

				end

				describe "The application doesn't exist" do

					it "should return the user to the not found page" do
						@appli.stub(:nil?){true}
						delete '/applications/appliTest', {}, @session
						last_response.should be_ok
						last_response.body.should match %r{<title>Not found</title>.*}
					end

				end

			end

			describe "The current_user doesn't exist" do

				it "should return the user to the forbidden page" do
					delete '/applications/appliTest'
					last_response.should be_ok
					last_response.body.should match %r{<title>Forbidden</title>.*}
				end

			end

		end

	end
	# END APPLICATION

	#---------------------------------------------------------------

	#------------------------------------
	# CLIENT APPLICATION AUTHENTICATION
	#------------------------------------
	describe "Client Application Connection" do

		describe "get /sessions/new/:appli" do

			it "should get /sessions/new/appli_1?origine=/protected" do
				get '/sessions/new/appli_1?origine=/protected'
				last_response.should be_ok
				last_request.path.should == '/sessions/new/appli_1'
			end

			describe "The application appli_1 exists" do

				before(:each) do
					@params = { 'name' => 'appli1Name', 'url' => 'http://localhost:2000' }
					Application.stub(:exists?){true}
				end

				it "should use exists? method from Application class" do
					Application.should_receive(:exists?).with("appli_1")
					get '/sessions/new/appli_1?origine=/protected'
				end

				describe "The current_user (session) exists" do

					before(:each) do
						@session = { "rack.session" => { :current_user => "tmorisse" } }
					end

					it "should exist a current_user (session)" do
						get '/sessions/new/appli_1?origine=/protected', {}, @session
						last_request.env["rack.session"][:current_user].should == "tmorisse"
					end

					describe "Utilization of application by a user" do

						describe "The user have never used this appli before" do

							before(:each) do
								Utilization.stub(:exists?){false}
								Utilization.stub(:add)
							end

							it "should use the exists? method" do
								Utilization.should_receive(:exists?).with("tmorisse", "appli_1")
								get '/sessions/new/appli_1?origine=/protected', {}, @session
							end

							it "should add the utilization of this appli into the database" do
								Utilization.should_receive(:add).with("tmorisse", "appli_1")
								get '/sessions/new/appli_1?origine=/protected', {}, @session
							end

						end

					end

					before(:each) do
						@appli = double(Application)
						Application.stub(:redirect){'http://localhost:2000/protected?login=tmorisse&secret=iamsauth'}
						Utilization.stub(:exists?){true}
					end

					it "should use the redirect method from Application class" do
						Application.should_receive(:redirect).with('appli_1', '/protected', 'tmorisse')
						get '/sessions/new/appli_1?origine=/protected', {}, @session
					end

					it "should redirect the user to the client application page" do
						get '/sessions/new/appli_1?origine=/protected', {}, @session
						last_response.should be_redirect
						follow_redirect!
						last_request.url.should == 'http://localhost:2000/protected?login=tmorisse&secret=iamsauth'
					end

				end

				describe "The current_user (session) doesn't exist" do

					before(:each) do
						Application.stub(:back_url){'http://localhost:2000/protected'}
					end

					it "should use back_url method from Application class" do
						Application.should_receive(:back_url).with('appli_1', '/protected')
						get '/sessions/new/appli_1?origine=/protected'
					end

					it " should render the form to post s_auth authentication info" do
						get '/sessions/new/appli_1?origine=/protected'
						last_response.should be_ok
						last_response.body.should match %r{<form.*action="/sessions/appli_1".*method="post".*}
					end

				end

			end

			describe "The application appli_1 doesn't exist" do

				it "should return the user to the not found page" do
					Application.stub(:exists?){false}
					get '/sessions/new/appli_1?origine=/protected'
					last_response.should be_ok
					last_response.body.should match %r{<title>Not found</title>.*}
				end

			end

		end

		describe "post /sessions/:appli" do

			describe "The user exists (authentication ok)" do

				before(:each) do
					@params = {'login' => 'tmorisse', 'password' => 'passwordThib', 'back_url' => 'http://localhost:2000/protected'}
					User.stub(:exists?){true}
				end

				it "should use the exists? method from User class" do
					User.should_receive(:exists?).with('tmorisse', 'passwordThib')
					post 'sessions/appli_1', @params
				end

				it "should create a current_user (session)" do
					post 'sessions/appli_1', @params
					last_request.env["rack.session"][:current_user].should == 'tmorisse'
				end

				describe "Utilization of application by a user" do

					describe "The user have never used this appli before" do

						before(:each) do
							Utilization.stub(:exists?){false}
							Utilization.stub(:add)
						end

						it "should use the exists? method from Utilization class" do
							Utilization.should_receive(:exists?).with("tmorisse", "appli_1")
							post 'sessions/appli_1', @params
						end

						it "should add the utilization of this appli into the database" do
							Utilization.should_receive(:add).with("tmorisse", "appli_1")
							post 'sessions/appli_1', @params
						end

					end

				end

				it "should redirect the user to the back_url" do
					Utilization.stub(:exists?){true}
					post 'sessions/appli_1', @params
					last_response.should be_redirect
					follow_redirect!
					last_request.url.should == 'http://localhost:2000/protected?login=tmorisse&secret=iamsauth'
				end

			end

			describe "The user doesn't exist (authentication not ok)" do

				before(:each) do
					@params = {'login' => 'tmorisse', 'password' => 'passwordThib', 'back_url' => 'http://localhost:2000/protected'}
					User.stub(:exists?){false}
					@user = double(User)
					User.stub(:find_by_login){@user}
				end

				it "should use find_by_login" do
					User.should_receive(:find_by_login).with('tmorisse')
					post 'sessions/appli_1', @params
				end

				it "should rerender the form if the user is unknown" do
					@user.stub(:nil?).and_return(true)
					post 'sessions/appli_1', @params
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/sessions/appli_1".*method="post".*}
				end

				it "should rerender the form if the password is wrong" do
					@user.stub(:nil?).and_return(false)
					post 'sessions/appli_1', @params
					last_response.should be_ok
					last_response.body.should match %r{<form.*action="/sessions/appli_1".*method="post".*}
				end

			end

		end

	end

end
