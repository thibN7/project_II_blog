require 'spec_helper'

describe "ShowingPosts" do

  describe "ShowingPosts" do

    before(:each) do
      @post1 = Post.create(:title => "sujet1", :body => "bla bla 1")
      @post2 = Post.create(:title => "sujet2", :body => "bla bla 2")
    end

    it "should have a link by post in the listing posts page to show a post" do
			visit posts_path
			page.should have_link('Show', :href => post_path(@post1))
			page.should have_link('Show', :href => post_path(@post2))
    end

		it "should render the page of the post1" do
			visit post_path(@post1)
			current_path.should == post_path(@post1)
		end

		it "should have the title and the body of the post 1" do
			visit post_path(@post1)
			page.should have_content @post1.title
			page.should have_content @post1.body
		end

		it "should have a link 'Index' to come back at the listing posts page" do
			visit post_path(@post1)
			page.should have_link('Index', :href => posts_path)
		end

  end

end
