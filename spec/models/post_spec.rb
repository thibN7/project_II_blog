require 'spec_helper'

describe Post do
  
    describe "With good information" do

      it "should be valid with a title and a body" do
        @params = { 'post' => {"title" => "titre1", "body" => "Corps du titre 1"}}
        post = Post.create(@params['post'])
        post.should be_valid
      end

    end




end
