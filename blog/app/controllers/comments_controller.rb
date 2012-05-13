class CommentsController < ApplicationController

	#before_filter :must_be_connected, :only => [:create, :destroy]

	def create
		@post = Post.find(params[:post_id])
		@post.comments.create(params[:comment])
		redirect_to(post_path(@post)) 
	end

	def destroy
		@post = Post.find(params[:post_id])
		comment = @post.comments.find(params[:id])
		comment.destroy
		redirect_to(post_path(@post))
	end

end
