require 'active_record'

class Application < ActiveRecord::Base
	belongs_to :user

  has_many :utilizations
  has_many :users, :through => :utilizations

  validates :name, :presence => true
  validates :name, :uniqueness => true

  validates :url, :presence => true
  validates :url, :uniqueness => true
	validates :url, :format => { :with => /^http?:\/\/[a-z0-9._\/-]+/i, :on => :create }

	validates :user_id, :presence => true
	validates :user_id, :numericality => true



	#DELETE METHOD
	def self.delete(appli)
		
		utilizations = Utilization.where(:application_id => appli.id)

		if utilizations != nil
			utilizations.each do |util|
    		util.destroy
    	end
		end
    appli.destroy

	end


	#REDIRECT METHOD
	def self.redirect(appliName, origin, userLogin)
		appli = Application.find_by_name(appliName)
		redirection = appli.url + origin + '?login=' + userLogin
		redirection
	end


	#BACK_URL METHOD
	def self.back_url(appliName, origin)
		appli = Application.find_by_name(appliName)
		back_url = appli.url + origin
		#back_url = appliName + origin
		back_url

	
	end




	#APPLICATION EXISTS METHOD
	def self.exists?(appliName)
		!self.find_by_name(appliName).nil?
	end		


end
