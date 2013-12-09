# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'data_mapper'
require 'sinatra'
require 'haml'
require 'rack/csrf'
require 'json'
require 'sinatra/cookies'
require 'sinatra/json'


get '/' do
  haml :index
end
