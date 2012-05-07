require 'spec_helper'

describe "posts/new.html.erb" do

	it "renders the form to post new post" do
		render
		rendered.should =~ /New post/
		rendered.should have_content('Title')
		rendered.should have_content('Body')
	end

end
