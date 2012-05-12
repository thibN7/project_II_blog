require 'spec_helper'

describe "DeletingComments" do

  describe "GET /deleting_comments" do

		before(:each) do
			@post = Post.create(:title => "Titre post 1", :body => "Ceci est le corps du post numero 1")
			@comment1 = @post.comments.create(:writer => "Thibault" , :body => "Ceci est le corps de Thibault. Enfin, de ce qu'il dit...")
			@comment2 = @post.comments.create(:writer => "Thibthib" , :body => "Salut moi c'est Thibthib.")
		end

		it "should have a 'Delete' link per comment in the show post page to delete a comment" do
			visit post_path(@post)
			page.should have_link('Delete' , :href => comment_path(@post, @comment1))
			page.should have_link('Delete' , :href => comment_path(@post, @comment2))
		end

		it "should delete the comment" do
			visit post_path(@post)
			click_link('Delete')
			current_path.should == post_path(@post)
			page.should have_no_content(@comment1.writer)
			page.should have_no_content(@comment1.body)
			page.should have_content(@comment2.writer)
			page.should have_content(@comment2.body)
		end

		it "should redirect to the post page (the page where we are)" do
			visit post_path(@post)
			click_link('Delete')
			current_path.should == post_path(@post)
		end

  end

end
