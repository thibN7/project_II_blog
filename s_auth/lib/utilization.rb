require 'active_record'

class Utilization < ActiveRecord::Base
  belongs_to :user			# foreign key - user_id
  belongs_to :application	# foreign key - application_id




	#UTILIZATION EXISTS METHOD
	def self.exists?(userLogin, appName)
		user = User.find_by_login(userLogin)
		appli = Application.find_by_name(appName)
		if !user.nil? && !appli.nil?
			self.where('user_id'=>user.id, 'application_id'=>appli.id) != []
		else
			false
		end
	end	


	# ADD METHOD
	def self.add(userLogin, appName)
		user = User.find_by_login(userLogin)
		appli = Application.find_by_name(appName)
		self.create('user_id'=>user.id, 'application_id'=>appli.id)
	end



end


