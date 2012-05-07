require 'spec_helper'

describe "EditingPosts" do
  
	describe "EditingPosts" do

    before(:each) do
      @post1 = Post.create(:title => "sujet1", :body => "bla bla 1")
      @post2 = Post.create(:title => "sujet2", :body => "bla bla 2")
    end

    it "should have a link per post in the listing posts page to edit a post" do
			visit posts_path
			page.should have_link('Edit', :href => edit_post_path(@post1))
			page.should have_link('Edit', :href => edit_post_path(@post2))
    end

		it "should render the editing page of the post1" do
			visit edit_post_path(@post1)
			current_path.should == edit_post_path(@post1)
			page.should have_content('Edit post')
		end

		it "should update the post1 information and come back to the listing posts page" do
			visit edit_post_path(@post1)
			fill_in('Title', :with => 'titre 1 modifie')
      fill_in('Body', :with => 'blabla1 modifie aussi')
      click_button('Update')
      current_path.should == posts_path
      page.should have_content('titre 1 modifie')
			page.should have_no_content('sujet1')
		end


  end

end
