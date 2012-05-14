require 'spec_helper'

describe "posts/index.html.erb" do

	describe "User connected" do

		before(:each) do
			view.stub(:is_connected?){true}
			view.stub(:current_user){"thibault"}
		end

		it "should display the login of the connected user" do
			render
			rendered.should =~ /Connected/
			rendered.should =~ /thibault/
		end

		it "should have a link called 'Disconnect' to disconnect the user" do
			render
			rendered.should have_link('Disconnect', :href => session_path)
		end

	end

	describe "User not connected" do

		before(:each) do
			view.stub(:is_connected?){false}
		end

		it "should display 'Not Connected'" do
			render
			rendered.should =~ /Not connected/
		end

		it "should have a link called 'Sign-in'" do
			render
			rendered.should have_link('Sign-in', :href => new_session_path)
		end

	end

	before(:each) do
		assign(:posts, [
			stub_model(Post, :id => "1", :title => "sujet 1"),
			stub_model(Post, :id => "2", :title => "sujet 2")
		])
		view.stub(:is_connected?){true}
		view.stub(:current_user){"thibault"}
	end

  it "displays all the posts" do
    render
    rendered.should =~ /sujet 1/
    rendered.should =~ /sujet 2/
  end

	it "has a link called 'New post'" do
		render
		rendered.should have_link('New post', :href => new_post_path)
	end

	it "has a link called 'Delete' for each post" do
		render
		rendered.should have_link('Delete', :href => post_path(1))
		rendered.should have_link('Delete', :href => post_path(2))
	end

	it "has a link called 'Show' for each post" do
		render
		rendered.should have_link('Show', :href => post_path(1))
		rendered.should have_link('Show', :href => post_path(2))
	end

	it "has a link called 'Edit' for each post" do
		render
		rendered.should have_link('Edit', :href => edit_post_path(1))
		rendered.should have_link('Edit', :href => edit_post_path(2))
	end

end
