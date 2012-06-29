require 'bundler/setup'
require 'heroku_san'

class SimpleDeployStrategy < HerokuSan::Deploy::Base
  def deploy
    super
  end
end

config_file = File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'heroku.yml')
HerokuSan.project = HerokuSan::Project.new(config_file, :deploy => SimpleDeployStrategy)

load 'heroku_san/tasks.rb'
