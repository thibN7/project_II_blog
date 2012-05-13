require_relative 'spec_helper'

require 'application'

describe Application do

	before(:each) do	
		User.all.each{|user| user.destroy}
		Application.all.each{|appli| appli.destroy}
	end

	after(:each) do	
		User.all.each{|user| user.destroy}
		Application.all.each{|appli| appli.destroy}
	end

	#-----------------------------
	# USED METHODS
	#-----------------------------
	describe "Used methods" do

		it "should have the name" do
			subject.should respond_to :name
		end

		it "should have the url" do
			subject.should respond_to :url
		end

		it "should have the user id" do
			subject.should respond_to :user_id
		end
	
	end	

	#--------------------
	# VALID? METHOD
	#--------------------
  describe "Valid?" do

    it "should not be valid without an url" do
	 		subject.name = "NomAppli"
      subject.user_id = "12"
      subject.valid?.should be_false
    end

		it "should not be valid with an empty name" do
			subject.name = ""
			subject.url = "http://www.url.fr/"
      subject.user_id = "12"
			subject.valid?.should be_false
		end

    it "should not be valid without a name" do
	 		subject.url = "http://www.url.fr/"
      subject.user_id = "12"
      subject.valid?.should be_false
    end

		it "should not be valid with an empty url" do
			subject.name = "NomAppli"
			subject.url = ""
      subject.user_id = "12"
			subject.valid?.should be_false
		end

		it "should be valid with an url which starts by http://" do
			subject.name = "NomAppli"
			subject.url = "http://toto"
      subject.user_id = "12"
			subject.valid?.should be_true
		end

    it "should not be valid without a name and an url" do
      subject.user_id = "12"
      subject.valid?.should be_false
    end

		it "should not be valid without the user id" do
			subject.name = "NomAppli"
			subject.url = ""
      subject.valid?.should be_false
		end

    it "should not be valid with two identical urls" do
	 		subject.name = "Appli1"
      subject.url = "http://www.url1.fr/"
			subject.user_id = "12"
      subject.save
      appli = Application.new
      appli.name = "Appli2"
      appli.url = "http://www.url1.fr/"
			subject.user_id = "12"
      appli.valid?.should be_false
			subject.destroy
    end

    it "should not be valid with two identical names" do
	 		subject.name = "AppliTest"
      subject.url = "http://www.urlTest1.fr/"
			subject.user_id = "12"
      subject.save
      appli = Application.new
      appli.name = "AppliTest"
      appli.url = "http://www.urlTest2.fr/"
			subject.user_id = "12"
      appli.valid?.should be_false
    end

    it "should not be valid with two identical names and urls" do
	 		subject.name = "Appli"
      subject.url = "http://www.url.fr/"
			subject.user_id = "12"
      subject.save
      appli = Application.new
      appli.name = "Appli"
      appli.url = "http://www.url.fr/"
			subject.user_id = "12"
      appli.valid?.should be_false
    end


		describe "Store the user id" do

			before(:each) do
				subject.name = "Appli"
		    subject.url = "http://www.url.fr/"
			end

			it "should not store something different than an integer as user id" do
				subject.user_id = "toto33"
		    subject.save
				subject.valid?.should be_false
			end

			it "should not store an integer as user id" do
				subject.user_id = "12"
		    subject.save
				subject.valid?.should be_true
			end

		end

  end

	#--------------------
	# DELETE METHOD
	#--------------------
	describe "Delete an application" do

		before(:each) do
			@paramsUser1 = {'login' => 'tmomo','password' => 'passwordThib'}
			User.create(@paramsUser1)
			@user1 = User.find_by_login('tmomo')
			Application.create('name' => 'nomAppli','url' => 'http://urlAppli.fr','user_id' => @user1.id)
			@appli = Application.find_by_name('nomAppli')
		end

		it "should delete a known application selected by the owner" do
			Application.delete(@appli)
			Application.find_by_id(@appli.id).should be_nil
		end
		
	end

	#-------------------------------
	# BACK URL
	#-------------------------------
	describe "Back Url Application" do

		before(:each) do
			@paramsUser1 = {'login' => 'tmomo','password' => 'passwordThib'}
			User.create(@paramsUser1)
			@user1 = User.find_by_login('tmomo')
			Application.create('name' => 'nomAppli','url' => 'http://urlAppli.fr','user_id' => @user1.id)
		end

		it "should return the application back_url" do
			Application.back_url('nomAppli', '/protected').should == 'http://urlAppli.fr/protected'
		end

	end


	#-------------------------------
	# APPLICATION URL REDIRECTION
	#-------------------------------
	describe "Application Url Redirection" do

		before(:each) do
			@paramsUser1 = {'login' => 'tmomo','password' => 'passwordThib'}
			User.create(@paramsUser1)
			@user1 = User.find_by_login('tmomo')
			Application.create('name' => 'nomAppli','url' => 'http://urlAppli.fr','user_id' => @user1.id)
		end

		it "should redirect the user to the adress he/she comes from and with the login as parameter" do
			Application.redirect('nomAppli', '/protected', 'tmomo').should == 'http://urlAppli.fr/protected?login=tmomo'
		end
		
	

	end
	# END APPLICATION URL REDIRECTION

	
	#-------------------------------
	# EXISTS? METHOD
	#-------------------------------
	describe "Application exists? method" do
		
		describe "The application exists" do

			it "should return true" do
				Application.create('name' => 'nomAppli','url' => 'http://urlAppli.fr','user_id' => 12)
				Application.exists?('nomAppli').should be_true
			end

		end

		describe "The application doesn't exist" do

			it "should return false" do
				Application.exists?('nomAppli').should be_false
			end

		end

	end




end
