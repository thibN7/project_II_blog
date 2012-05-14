require 'spec_helper'

describe SessionsController do

	describe "User not connected" do

		it "should redirect the user to the s_auth" do
			get 'new'
			response.should redirect_to('http://localhost:4567/sessions/new/appli_blog?origine=/sessions/new')
		end

		describe "s_auth response" do

			before do
				@params = {'secret' => "iamsauth", "login" => "toto"}
			end

			it "should redirect to the posts_path" do
				get 'new', @params
				response.should redirect_to(posts_path)
			end
       
			it "should set the session" do
				get 'new', @params
				request.env["rack.session"]["current_user_blog"].should == "toto"
			end

		end

	end

	describe "User connected" do

		it "should redirect the user to the listing posts page" do
			request.env["rack.session"]["current_user_blog"] = "toto"
			get 'new'
			response.should redirect_to(posts_path)
		end

	end 

	describe "destroy" do

		it "should delete the session" do
			request.env["rack.session"]["current_user_blog"] = "toto"
			delete 'destroy'
			request.env["rack.session"]["current_user_blog"].should == nil
		end

		it "should redirect the user to the posts_path" do
			delete 'destroy'
			response.should redirect_to(posts_path)
		end

	end

end
