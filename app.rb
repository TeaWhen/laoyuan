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
  puts params
  haml :thx
end
