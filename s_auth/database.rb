require 'active_record'
require_relative 'lib/user'
require_relative 'lib/application'
require_relative 'lib/utilization'

config_file = File.join(File.dirname(__FILE__),"config","database.yml")

puts YAML.load(File.open(config_file)).inspect

base_directory = File.dirname(__FILE__)

# ajoute le répertoire courant devant le chemin pour trouver la base de données
configuration = YAML.load(File.open(config_file))["development"]
configuration["database"] = File.join(base_directory, configuration["database"])

ActiveRecord::Base.establish_connection(configuration)



