require 'spec_helper'

describe "posts/index.html.erb" do

  it "displays all the posts" do
    assign(:posts, [
           stub_model(Post, :title => "sujet 1"),
           stub_model(Post, :title => "sujet 2")
          ])
    render
    rendered.should =~ /sujet 1/
    rendered.should =~ /sujet 2/
  end




end
