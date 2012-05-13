require 'spec_helper'

describe CommentsController do 

	it "should route to #create" do
		post('/posts/1/comments').should route_to("comments#create", :post_id => "1")
	end

	it "routes to #delete" do 
		delete('/posts/1/comments/1').should route_to("comments#destroy", :post_id => "1", :id => "1")
	end


end
