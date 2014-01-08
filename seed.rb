# encoding: utf-8

require_relative 'db'
require 'rubygems'
require 'bundler/setup'
require 'roo'
require 'json'

questions = [
  "教学态度是否认真端正",
  "是否有组织或参与违规有偿办班补课行为",
  "是否有违规强制学生订购教辅资料行为",
  "是否有体罚或以侮辱、歧视、孤立等方式变相体罚学生行为",
  "是否有索要或违反规定收受家长、学生财物等行为"
]

questions.each do |quest|
  qq = Question.new
  qq.description = quest
  qq.save
end

@schools = {}

xls = Roo::Excel.new("data/3.xls")
f = File.new("pass.txt", "w")

xls.each_with_pagename do |name, sheet|
  (1..(sheet.last_row)).each do |rnum|
    row = sheet.row(rnum)
    sname = row[0].strip
    unless @schools.keys.include? sname
      sch = School.new
      sch.username = sname
      rand_pass = ""
      8.times { rand_pass += "abcdefghijkmnpqrstuvwxyz123456789".split('').sample }
      sch.password = rand_pass
      sch.school_name = sname
      sch.save
      @schools[sname] = rand_pass
    end
    sch = School.first(:school_name => sname)
    tea = Teacher.new
    tea.name = row[2]
    tea.subject = row[1].strip
    tea.school = sch
    tea.save
  end
end

f.puts(@schools.to_json)
f.close
