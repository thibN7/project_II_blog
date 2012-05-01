class PostsController < ApplicationController

  def index
		@posts = Post.all
  end

  def new
		@posts = Post.new
  end

	def create
		post = Post.create(params[:post])
		redirect_to(posts_path)
	end

	def destroy
		post = Post.find(params[:id])
		post.destroy
		redirect_to(posts_path)
	end

	def show
		@post = Post.find(params[:id])
	end

end
