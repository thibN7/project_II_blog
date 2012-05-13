require 'spec_helper'

describe "posts/show.html.erb" do

	before(:each) do
		@post = stub_model(Post, :title => "titre 1", :body => "blabla 1")
		@comment1 = @post.comments.create({:writer => "Thibault", :body => "Premier commentaire"})
		@comment2 = @post.comments.create({:writer => "Thibthib", :body => "Second commentaire"})
		assign(:post, @post)
	end
  
	it "displays the title and the body of a post" do
		render
		rendered.should =~ /titre 1/
		rendered.should =~ /blabla 1/
	end

	it "displays the comments linked to the post" do
		render
		rendered.should =~ /Thibault/
		rendered.should =~ /Premier commentaire/
		rendered.should =~ /Thibthib/
		rendered.should =~ /Second commentaire/
	end

	it "has a link called 'Delete' for each comment" do
		render
		rendered.should have_link('Delete', :href => comment_path(@post, @comment1))
		rendered.should have_link('Delete', :href => comment_path(@post, @comment2))
	end

	it "has a link called 'Index'" do
		render
		rendered.should have_link('Index', :href => posts_path)
	end

end
