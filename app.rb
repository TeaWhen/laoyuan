# encoding: utf-8

require_relative 'db'

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'rack/csrf'
require 'json'
require 'sinatra/cookies'
require 'sinatra/json'
require 'redis'

configure do
  use Rack::Session::Cookie, :secret => "xfpSs949xpMQVmKC6mSQrWKP"
  use Rack::Csrf, :raise => true
end

helpers do
  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def check_login
    unless cookies[:sid]
      redirect '/login/'
    end
    school = School.first(:id => cookies[:sid])
    unless school
      redirect '/login/'
    end
    return school
  end
end

get '/' do
  @title = "选学校"
  @schools = School.all
  haml :index
end

get '/login/?' do
  @title = "登录"
  haml :login
end

post '/login/?' do
  @errors = []
  unless params[:username].length > 0
    @errors.push("请填写用户名")
  end
  unless params[:password].length > 0
    @errors.push("请填写密码")
  end
  if @errors.length == 0
    school = School.first(:username => params[:username])
    unless school
      @errors.push "无效的用户名或密码"
    else
      if school.password == params[:password]
        cookies[:sid] = school.id
        redirect '/teachers/'
      else
        @errors.push "无效的用户名或密码"
      end
    end
  end
  @title = "登录"
  haml :login
end

get '/teachers/?' do
  @title = "选教师"
  school = check_login
  teas = school.teachers
  @teachers = {}
  teas.each do |tea|
    unless @teachers.keys.include? tea.subject
      @teachers[tea.subject] = Array.new
    end
    @teachers[tea.subject] << tea
  end
  haml :teachers
end

get '/vote/:tid/?' do
  @title = "投票"
  school = check_login
  @teacher = Teacher.get(params[:tid])
  unless school.teachers.include? @teacher
    redirect '/login/'
  end
  @questions = Question.all
  haml :vote
end

post '/vote/?' do
  school = check_login
  teacher = Teacher.get(params[:tid])
  unless school.teachers.include? teacher
    redirect '/login/'
  end
  redis = Redis.new(:port => 7772)
  if (redis.sismember "t#{teacher.id}ips", request.ip)
    redirect '/err/'
  else
    redis.multi do
      redis.sadd "t#{teacher.id}ips", request.ip
      redis.sadd "t#{teacher.id}votes", {ip: request.ip, raw: params.to_json}
      questions = Question.all
      questions.each do |quest|
        if params[quest.id.to_s] == "yes"
          redis.incr "t#{teacher.id}q#{quest.id}"
        end
      end
    end
  end
  redirect '/thx/'
end

get '/thx/?' do
  @title = "谢谢"
  haml :thx
end

get '/err/?' do
  @title = "错误"
  haml :err
end

get '/dash/?' do
  if params[:token] == "gGQtQbfMbnrdcUJknAgAHRmZeDAMJYXNF9xFQwG6vCYcWHzbHxCJqAd7dWEv2xegnDHZ5PSQ"
    redis = Redis.new(:port => 7772)
    @qids = Question.all.map { |e| e.id }
    @tinfos = []
    schools = School.all
    schools.each do |sch|
      sch.teachers.each do |t|
        tea_info = {count: redis.scard("t#{t.id}votes"), name: t.name, subject: t.subject, school: t.school}
        @qids.each do |qid|
          tea_info[qid] = redis.get "t#{t.id}q#{qid}"
          unless tea_info[qid]
            tea_info[qid] = 0
          end
        end
        @tinfos.push tea_info
      end
    end
    haml :dash
  end
end
