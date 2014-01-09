# encoding: utf-8

require_relative 'db'
require 'rubygems'
require 'bundler/setup'
require 'csv'

CSV.open("pass.csv", "wb") do |csv|
  csv << ["学校", "用户名", "密码"]
  ss = School.all
  ss.each do |s|
    rand_pass = ""
    8.times { rand_pass += "abcdefghijkmnpqrstuvwxyz123456789".split('').sample }
    s.password = rand_pass
    s.save
    csv << [s.school_name, s.username, rand_pass]
  end
end
