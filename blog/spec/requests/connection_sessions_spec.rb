require 'spec_helper'
require 'capybara/mechanize'

describe "ConnectionSessions", :driver => :mechanize do

  describe "GET /sessions/new" do

    it "should have a link called 'Sign-in' in the listing posts page to be connected" do
			visit posts_path
			page.should have_link('Sign-in', :href => new_session_path)
    end

    it "should redirect to the sauth" do
      visit posts_path
      click_link('Sign-in')
      current_path.should == "/sessions/new/appli_blog"
      page.should have_content('Authentication')
    end

		it "should connect the user to the blog" do
      visit posts_path
      click_link('Sign-in')
      fill_in('login', :with => 'toto')
      fill_in('password', :with => 'toto')
      click_button('Log-in')
      current_path.should == posts_path
      page.should have_content('New post')
    end

  end

end
