require 'spec_helper'

describe "CreateComments" do

	before(:each) do
		@post = Post.create(:title => "Titre post 1", :body => "Ceci est le corps du post numero 1")
	end

  describe "GET /posts/:id" do

		it "should print the form to create a comment" do
			visit post_path(@post)
			page.should have_selector('form')
			page.should have_content('Writer')
			page.should have_field('comment[writer]')
			page.should have_content('Body')
			page.should have_field('comment[body]')
		end

  end

	describe "POST /posts/:id/comments" do
		
		it "should create the comment and render it to the post page" do
			visit post_path(@post)
			fill_in('Writer', :with => 'Toto')
			fill_in('Body', :with => 'Ceci est le corps de Toto. Enfin...')
			click_button('Add a comment')
			current_path.should == post_path(@post)
			page.should have_content('Toto')
			page.should have_content('Ceci est le corps de Toto. Enfin...')
		end

	end

end
