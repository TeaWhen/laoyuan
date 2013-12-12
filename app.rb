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
  @title = "登录"
  haml :login
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
  @teachers = school.teachers
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
  redis = Redis.new
  redis.multi do
    redis.sadd "t#{teacher.id}ips", request.ip
    redis.sadd "votes", {ip: request.ip, raw: params.to_json, tid: teacher.id}
    questions = Question.all
    questions.each do |quest|
      if params[quest.id.to_s] == "yes"
        redis.incr "t#{teacher.id}q#{quest.id}"
      end
    end
  end
  redirect '/thx/'
end

get '/thx/?' do
  @title = "谢谢"
  haml :thx
end

get '/dash/?' do
  redis = Redis.new
  @all_count = redis.scard "votes"
  @qs = []
  questions = Question.all
  questions.each do |quest|
    @qs.push({description: quest.description, id: quest.id, count: redis.get("q#{quest.id}")})
  end
  haml :dash
end
