require_relative 'spec_helper'

require 'utilization'

describe Utilization do

	before(:each) do	
		Utilization.all.each{|util| util.destroy}
		Application.all.each{|appli| appli.destroy}
		User.all.each{|user| user.destroy}
	end

	after(:each) do	
		Utilization.all.each{|util| util.destroy}
		Application.all.each{|appli| appli.destroy}
		User.all.each{|user| user.destroy}
	end

	#-------------------------------
	# EXISTS? METHOD
	#-------------------------------
	describe "Utilization exists? method" do

		before(:each) do
			paramsUser1 = {'login' => 'tmorisse', 'password' => 'passwordThib'}
			paramsUser2 = {'login' => 'titi', 'password' => 'pwdTiti'}
			paramsAppli1 = {'name' => 'appli_1', 'url' => 'http://urlAppli1.fr', 'user_id' => 12}
			paramsAppli2 = {'name' => 'appli_2', 'url' => 'http://urlAppli2.fr', 'user_id' => 33}
			User.create(paramsUser1)
			User.create(paramsUser2)
			Application.create(paramsAppli1)
			Application.create(paramsAppli2)
			user1 = User.find_by_login('tmorisse')
			user2 = User.find_by_login('titi')
			appli1 = Application.find_by_name('appli_1')
			appli2 = Application.find_by_name('appli_2')
			Utilization.create('user_id'=>user1.id, 'application_id'=>appli1.id)
			Utilization.create('user_id'=>user2.id, 'application_id'=>appli2.id)
		end

		describe "The utilization of an application by a user exists" do

			it "should return true" do
				!Utilization.exists?('tmorisse','appli_1').should be_true
			end

		end
		
		describe "The utilization of an application by a user doesn't exist" do

			it "should return false if the user and the appli don't exist" do
				!Utilization.exists?('toto','appli_fake').should be_false
			end

			it "should return false if the user exists but not the appli" do
				!Utilization.exists?('tmorisse','appli_fake').should be_false
			end

			it "should return false if the appli exists but not the user" do
				!Utilization.exists?('toto','appli_1').should be_false
			end

			it "should return false if an existing user doesn't use an existing appli" do
				!Utilization.exists?('tmorisse','appli_2').should be_false
			end

		end
	
	end


	#-------------------------------
	# ADD METHOD
	#-------------------------------
	describe "Utilization add method" do

		before(:each) do
			paramsUser = {'login' => 'tmorisse', 'password' => 'passwordThib'}
			paramsAppli = {'name' => 'appli_1', 'url' => 'http://urlAppli1.fr', 'user_id' => 12}
			User.create(paramsUser)
			Application.create(paramsAppli)
			@user = User.find_by_login('tmorisse')
			@appli = Application.find_by_name('appli_1')
		end

		it "should add an utilization between a user and an application" do
			Utilization.add('tmorisse', 'appli_1')
			Utilization.where('user_id'=>@user.id, 'application_id'=>@appli.id).should_not be_nil
		end

	end







end
