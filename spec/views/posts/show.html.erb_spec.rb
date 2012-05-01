require 'spec_helper'

describe "posts/show.html.erb" do

	before(:each) do
		assign(:post, stub_model(Post, :title => "titre 1", :body => "blabla 1"))
	end
  
	it "displays the title and the body of a post" do
		render
		rendered.should =~ /titre 1/
		rendered.should =~ /blabla 1/
	end

	it "has a link called 'Index'" do
		render
		rendered.should have_link('Index', :href => posts_path)
	end

end
