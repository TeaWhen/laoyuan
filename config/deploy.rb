require 'mina/bundler'
require 'mina/git'
require 'mina/rvm'

set :user, 'aquarhead'
set :domain, 'eclair.teawhen.com'
set :deploy_to, '/home/aquarhead/projects/laoyuan'
set :repository, 'git@github.com:TeaWhen/laoyuan.git'
set :branch, 'master'

task :environment do
  invoke :'rvm:use[2.0.0@laoyuan]'
end

task :setup => :environment do
  invoke :'rvm:wrapper[2.0.0@laoyuan,laoyuan-server,ruby]'
end

desc "Seed the database."
task :seed => :environment do
  in_directory "#{deploy_to}/current" do
    queue "ruby db.rb"
    queue "ruby seed.rb"
  end
end

desc "Wake redis."
task :wakeredis do
  in_directory "#{deploy_to}/current/dump" do
    queue "/opt/redis/redis-server redis.conf"
  end
end

desc "Wipe redis."
task :wiperedis do
  in_directory "#{deploy_to}/current/dump" do
    queue "kill -9 `more pid/redis.pid`"
    queue "rm -rf dump.rdb"
  end
end

desc "Reload redis."
task :reloadredis do
  invoke :wiperedis
  invoke :wakeredis
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'bundle:install'

    to :launch do
      queue "ruby #{deploy_to}/current/db.rb"
      queue "mkdir -p #{deploy_to}/current/tmp"
      queue "touch #{deploy_to}/current/tmp/restart.txt"
    end
  end
end
