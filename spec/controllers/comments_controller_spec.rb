require 'spec_helper'

describe CommentsController do

	describe "POST '/posts/:post_id/comments'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:find){@post}
			@comment = double(Comment)
			@post.stub(:comments){@comment}
			@comment.stub(:create)
			@params={:post_id => 1, :comment => {"writer" => "Thibault", "body" => "Corps du post de Thibault"}}
    end

		it "should use the 'find' method" do
			Post.should_receive(:find).with("1")
			post 'create', @params
		end

		it "should create a new comment" do
			@comment.should_receive(:create).with("writer" => "Thibault", "body" => "Corps du post de Thibault")
			post 'create', @params
		end
    
		it "should redirect to the post page" do
			post 'create', @params
			response.should redirect_to(post_path(@post))
		end

  end

end
