require 'spec_helper'

describe PostsController do 

  it "should route to #index" do 
    get('/posts').should route_to("posts#index")
  end

  it "should provide the aliast post_path for /posts" do 
    posts_path.should == '/posts'
  end

  it "should route to #new" do 
    get('/posts/new').should route_to("posts#new")
  end

  it "should provide the aliast new_post_path for /posts/new" do 
    new_post_path.should == '/posts/new'
  end

	it "should routes to #create" do
		post('/posts').should route_to("posts#create")
	end

end
