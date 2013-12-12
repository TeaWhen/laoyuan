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

sch = School.new
sch.username = "yizhong"
sch.password = "laoyuan"
sch.school_name = "一中"
sch.save

tea = Teacher.new
tea.name = "老苑"
tea.subject = "计算机"
tea.school = sch
tea.save
