require 'spec_helper'

describe "DeletingPosts" do

  describe "delete /posts" do

    before(:each) do
      @post1 = Post.create(:title => "sujet1", :body => "bla bla 1")
      @post2 = Post.create(:title => "sujet2", :body => "bla bla 2")
    end

		it "should have a link by post in the listing posts page to delete a post" do
			visit posts_path
			page.should have_link('Delete', :href => post_path(@post1))
			page.should have_link('Delete', :href => post_path(@post2))
		end

		it "should delete a post" do
			visit posts_path
			click_link('Delete')
			page.should have_no_content(@post1.title)
			page.should have_content(@post2.title)
		end

		it "should redirect to the listing posts page (the page where we are)" do
			visit posts_path
			click_link('Delete')
			current_path.should == posts_path
		end
    
  end

end
