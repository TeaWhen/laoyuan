# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'data_mapper'

DataMapper::setup(:default, "mysql://laoyuan:laoyuan@localhost/laoyuan")

class User
  include DataMapper::Resource
  property :id, Serial

  property :username, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true
  property :nickname, String, :required => true
end

class Question
  include DataMapper::Resource
  property :id, Serial

  property :description, String, :required => true
end

DataMapper.finalize

DataMapper.auto_upgrade!
