require 'spec_helper'

describe PostsController do


  describe "GET 'index'" do

    before(:each) do
      @posts = [stub_model(Post,:title => "1"), stub_model(Post, :title => "2")]
      Post.stub(:all){ @posts }
    end

    it "assigns a list of posts" do
      Post.should_receive(:all).and_return(@posts)
      get 'index'
      assigns(:posts).should eq @posts
      response.should be_success
    end

    it "renders the template list" do
      get 'index'
      response.should render_template(:index)
    end

  end

	describe "GET 'new'" do

		it "should use new" do
			Post.should_receive(:new)
			get 'new'
			response.should be_success
		end

    it "renders the template new" do
      get 'new'
      response.should render_template(:new)
    end

	end

	describe "POST '/posts'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:create){@post}
			@params={:post=>{:title=>"title",:body=>"content"}}
    end

		it "should create a new post" do
			Post.should_receive(:create).with("title"=>"title", "body"=>"content")
			post 'create', @params
		end
    
		it "should redirect to the listing posts page" do
			post 'create', @params
			response.should redirect_to(posts_path)
		end

  end

	describe "DELETE '/posts/:id'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:find){@post}
			@post.stub(:destroy)
			@params={:id=>"1"}
		end

		it "should use the 'find' method to find a post" do
			Post.should_receive(:find).with("1")
			delete 'destroy', @params
		end

		it "should use the 'destroy' method to delete the post" do
			@post.should_receive(:destroy)
			delete 'destroy', @params
		end

		it "should redirect the user to the listing posts page" do
			delete 'destroy', @params
			response.should redirect_to(posts_path)
		end		

	end

	describe "GET '/posts/:id'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:find){@post}
			@params={:id=>"1"}
		end

		it "should use the 'find' method to find a post" do
			Post.should_receive(:find).with("1")
			get 'show', @params
			response.should be_success
		end

		it "should render the 'show' template" do
			get 'show', @params
			response.should render_template(:show)
		end

	end

	describe "GET '/posts/:id/edit'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:find){@post}
			@params={:id=>"1"}
		end

		it "should use the 'find' method to find a post" do
			Post.should_receive(:find).with("1")
			get 'edit', @params
			response.should be_success
		end

		it "should render the 'edit' template" do
			get 'edit', @params
			response.should render_template(:edit)
		end

	end

	describe "PUT '/posts/:id'" do

		before(:each) do
			@post = double(Post)
			Post.stub(:find){@post}
			@post.stub(:update_attributes)
			@params={:id=>"1", :post=>{"title"=>"titre 1 modifie", "body"=>"blabla1 modifie aussi"}}
		end

		it "should use the 'find' method to find a post" do
			Post.should_receive(:find).with("1")
			put 'update', @params
		end		

		it "should use the 'update_attributes' method to update information" do
			@post.should_receive(:update_attributes).with(@params[:post])
			put 'update', @params
		end

		it "should redirect the user to the listing posts page" do
			put 'update', @params
			response.should redirect_to(posts_path)
		end

	end

	


end
