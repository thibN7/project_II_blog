require 'spec_helper'

describe "posts/edit.html.erb" do

	it "renders the form to edit post" do
		@post = stub_model(Post, :id => "1", :title => "titre 1 modifie", :body => "blabla1 modifie aussi")
		assign(:post, @post)
		render
		rendered.should =~ /Edit post/
		rendered.should have_content('Title')
		rendered.should have_content('Body')
	end

end
