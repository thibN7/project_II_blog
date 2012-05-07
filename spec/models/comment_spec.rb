require 'spec_helper'

describe Comment do
  
	before(:each) do
		Comment.all.each{|comment| comment.destroy}
		@paramsOk = {"writer" => "Thibault", "body" => "Premier commentaire", "post_id" => "1"}
		@paramsWithoutPostId = {"writer" => "Thibault", "body" => "Premier commentaire"}
		@paramsWithoutBody = {"writer" => "Thibault", "post_id" => "1"}
	end

	describe "Good information" do
		
		it "should be valid with a writer, a body and a post_id" do
			comment = Comment.create(@paramsOk)
			comment.should be_valid
		end

	end

	describe "Wrong information" do

		it "should not be valid without a post_id" do
		comment = Comment.create(@paramsWithoutPostId)
		comment.should_not be_valid
		end

		it "should not be valid without a body" do
		comment = Comment.create(@paramsWithoutBody)
		comment.should_not be_valid
		end		

	end

end
