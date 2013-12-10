# encoding: utf-8

require_relative 'db'
require 'rubygems'
require 'bundler/setup'

questions = [
  "是否办班补课",
  "是否推销或变向推销教辅资料",
  "教学态度是否端正"
]

questions.each do |quest|
  qq = Question.new
  qq.description = quest
  qq.save
end