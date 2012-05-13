require_relative 'spec_helper'

require 'user'

describe User do

	before(:each) do
		User.all.each{|user| user.destroy}
		Application.all.each{|appli| appli.destroy}
		Utilization.all.each{|util| util.destroy}
	end

	after(:each) do
		User.all.each{|user| user.destroy}
		Application.all.each{|appli| appli.destroy}
		Utilization.all.each{|util| util.destroy}
	end


	#-----------------------------
	# USED METHODS
	#-----------------------------
	describe "Used methods" do

		it "should have the login" do
			subject.should respond_to :login
		end

		it "should have the password" do
			subject.should respond_to :password
		end
	
	end	



	#-----------------------------
	# VALID? METHOD
	#-----------------------------
  describe "Valid? method" do

		describe "The user is valid" do
			
			it "should have a valid user" do
				subject.login = "Thibault"
				subject.password = "pwdThib"
				subject.valid?.should be_true
			end

		end

		describe "The user is not valid" do

			it "should not be valid without a password" do
		    subject.login = "Thibault"
		    subject.valid?.should be_false
		  end

			it "should not be valid with an empty password" do
				subject.login = "Thibault"
				subject.password = ""
		    subject.valid?.should be_false
			end
		  
		  it "should not be valid without a login" do
		    subject.password = "MotDePasse"
		    subject.valid?.should be_false        
		  end

			it "should not be valid with a login less than 4 characters" do
				subject.login = "lol"
				subject.valid?.should be_false
			end

			it "should not be valid with an empty login" do
				subject.login = ""
				subject.password = "MotDePasse"
		    subject.valid?.should be_false
			end

		  it "should not be valid without a login and a password" do
		    subject.valid?.should be_false  
		  end

		  it "should not be valid with two identical logins" do
		    subject.login = "Thib"
		    subject.password = "pass1"
		    subject.save
		    user1 = User.new
		    user1.login = "Thib"
		    user1.password = "pass1"
		    user1.valid?.should be_false
		  end

		end

    
    
  end 
	
	#-----------------------------
	# FIND BY LOGIN METHOD
	#-----------------------------
  describe "Find by login method" do

		describe "The login doesn't exist" do

			it "should return false if the authentication fails" do
				User.find_by_login('toto').should be_nil
			end

		end

		describe "The login exists" do

			it "should return true if the authentication succeeds" do
				subject.login = "Thib"
		    subject.password = "pass1"
		    subject.save
				User.find_by_login('Thib').should_not be_nil
			end

		end

  end


	#-----------------------------
	# PASSWORD
	#-----------------------------
	describe "Check Password" do

		before (:each) do
			subject.login = "Thib"
			subject.save
		end

		after(:each) do
			subject.destroy
		end

		it "should encrypt the password with sha1" do
		  Digest::SHA1.should_receive(:hexdigest).with("foo").and_return("0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33")
		  subject.password="foo"
			subject.password.should == "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"
  	end

		it "should store she sha1 digest" do
		  subject.password="foo"
		  subject.password.should == "0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"
		end

	end

	#----------------------
	# USER AUTHENTICATION
	#----------------------
	describe "User Authentication" do

		before (:each) do
			subject.login = "Thib"
			subject.password = "foo"
			subject.save
			subject.stub(:login).and_return("foo")
			subject.stub(:password).and_return("0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33")
		end

		after(:each) do
			subject.destroy
		end

		describe "Valid authentication" do

			it "should know the user" do
				User.should_receive(:find_by_login).with("Thib").and_return(subject)
				User.exists?("Thib", "foo").should be_true
			end

		end

		describe "Invalid authentication" do

			it "should not know the user because of wrong password" do
				User.should_receive(:find_by_login).with("Thib").and_return(@user)
				User.exists?("Thib", "toto").should be_false
			end

			it "should not know the user because of wrong login" do
				User.should_receive(:find_by_login).with("ThibThib").and_return(@user)
				User.exists?("ThibThib", "foo").should be_false
			end

		end

	end

	
	#----------------------
	# USER SUPPRESSION
	#----------------------
	describe "User Suppression method" do

		it "should delete the user, all the applications he has created, and the list of the utilizations of applications" do

			paramsUser = { 'login' => 'tmorisse', 'password' => 'passwordThib' }
			user = User.create(paramsUser)

			paramsAppli1 = { 'name' => 'appli_1', 'url' => 'http://localhost:2000', 'user_id' => user.id }
			appli_1 = Application.create(paramsAppli1)

			paramsAppli2 = { 'name' => 'appli_2', 'url' => 'http://localhost:2001', 'user_id' => user.id }
			appli_2 = Application.create(paramsAppli2)

			paramsUtilizations = { 'user_id' => user.id, 'application_id' => appli_1.id }
			Utilization.create(paramsUtilizations)

			User.find_by_login('tmorisse').should_not be_nil			
			Application.find_by_name('appli_1').should_not be_nil
			Application.find_by_name('appli_2').should_not be_nil
			Utilization.find_by_user_id(user.id).should_not be_nil

			User.delete(user)

			Utilization.find_by_user_id(user.id).should be_nil
			Application.find_by_name('appli_1').should be_nil
			Application.find_by_name('appli_2').should be_nil
			User.find_by_login('tmorisse').should be_nil			

		end

	end
		

	

	


end
