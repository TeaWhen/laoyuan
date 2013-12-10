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
end

get '/' do
  @questions = Question.all
  haml :index
end

post '/thx/?' do
  redis = Redis.new
  redis.multi do
    redis.sadd "ip_used", request.ip
    redis.sadd "votes", {ip: request.ip, raw: params.to_json}
    questions = Question.all
    questions.each do |quest|
      if params[quest.id.to_s] == "yes"
        redis.incr "q#{quest.id}"
      end
    end
  end
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
