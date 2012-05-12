require 'spec_helper'

describe CommentsController do 

	it "should route to #create" do
		post('/posts/1/comments').should route_to("comments#create", :post_id => "1")
	end


end
