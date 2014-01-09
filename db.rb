# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'data_mapper'

DataMapper::setup(:default, "mysql://laoyuan:laoyuan@localhost/laoyuan")

class School
  include DataMapper::Resource
  property :id, Serial

  property :username, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true
  property :school_name, String, :required => true

  has n, :teachers
end

class Teacher
  include DataMapper::Resource
  property :id, Serial

  property :name, String, :required => true
  property :subject, String, :required => true
  property :gender, String
  property :age, String

  belongs_to :school
end

class Question
  include DataMapper::Resource
  property :id, Serial

  property :description, String, :required => true
end

DataMapper.finalize

DataMapper.auto_upgrade!
