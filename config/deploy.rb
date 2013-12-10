require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'

set :user, 'aquarhead'
set :domain, 'eclair.teawhen.com'
set :deploy_to, '/home/aquarhead/projects/laoyuan'
set :repository, 'git@github.com:AquarHEAD/laoyuan.git'
set :branch, 'master'

task :environment do
  invoke :'rvm:use[2.0.0@laoyuan]'
end

task :setup => :environment do
  invoke :'rvm:wrapper[2.0.0@laoyuan,laoyuan-server,ruby]'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'

    to :launch do
      queue! "ruby #{deploy_to}/current/db.rb"
      queue! "mkdir -p #{deploy_to}/current/tmp"
      queue! "touch #{deploy_to}/current/tmp/restart.txt"
    end
  end
end
