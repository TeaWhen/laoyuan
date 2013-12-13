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

sch1 = School.new
sch1.username = "yizhong"
sch1.password = "laoyuan"
sch1.school_name = "一中"
sch1.save

sch2 = School.new
sch2.username = "erzhong"
sch2.password = "12345"
sch2.school_name = "二中"
sch2.save

sch3 = School.new
sch3.username = "sanzhong"
sch3.password = "12345"
sch3.school_name = "三中"
sch3.save

tea1 = Teacher.new
tea1.name = "老苑"
tea1.subject = "计算机"
tea1.school = sch
tea1.save

tea2 = Teacher.new
tea2.name = "占伟"
tea2.subject = "物理"
tea2.school = sch
tea2.save

tea3 = Teacher.new
tea3.name = "测试老师"
tea3.subject = "数学"
tea3.school = sch2
tea3.save

tea4 = Teacher.new
tea4.name = "测试2"
tea4.subject = "英语"
tea4.school = sch3
tea4.save
