require 'digest/sha1'
require 'active_record'

class User < ActiveRecord::Base

  # Relations
	has_many :applications
  has_many :utilizations
  has_many :applications, :through => :utilizations

  # Validators
  validates :login, :presence => true
  validates :login, :uniqueness => true
	validates :login, :format => { :with => /^[a-z0-9]{4,20}$/i, :on => :create }
	
	validates :password, :presence => true

	# Password
	def password=(password)
		if !password.empty?
			self[:password] = User.encrypt_password(password)
	  else
		  self[:password] = nil
		end
	end


	# Encrypt password
	def self.encrypt_password(password)
    Digest::SHA1.hexdigest(password).inspect[1..40]
	end


	# Exists?
	def self.exists?(login, password)
		user = User.find_by_login(login)
		!user.nil? && user.password == User.encrypt_password(password)
	end


	# Delete
	def self.delete(user)

		utilizations = Utilization.where(:user_id => user.id)
		applications = Application.where(:user_id => user.id)

		if utilizations
			utilizations.each do |utilization|
				Utilization.delete(utilization)
			end
		end

		if applications
			applications.each do |application|
				Application.delete(application)
			end
		end
		
		user.destroy
		
	end


	




end
