# encoding: utf-8

require_relative 'db'
require 'rubygems'
require 'bundler/setup'
require 'roo'

[
  "教学态度是否认真端正，是否有敬业精神？",
  "是否关爱学生，帮助学生树立正确的世界观、人生观、价值观 ？",
  "是否有高度的工作责任感和很强的教学能力？",
  "是否到学生家里家访，经常和家长沟通交流学生的情况？",
  "是否义务为学生补课、辅导？",
  "是否有组织或参与违规有偿办班补课行为？",
  "是否有违规强制学生订购教辅资料行为？",
  "是否有体罚或以侮辱、歧视、孤立等方式变相体罚学生行为？",
  "是否有课上不讲课下讲的现象？",
  "是否有索要或违反规定收受家长、学生财物等行为？",
  "您和孩子是否喜欢这位老师？"
].each do |quest|
  qq = Question.new
  qq.description = quest
  qq.save
end

# @schools = []

# xls = Roo::Excel.new("data/13.xls")
# xls.each_with_pagename do |name, sheet|
#   (1..(sheet.last_row)).each do |rnum|
#     row = sheet.row(rnum)
#     sname = row[0].strip
#     unless @schools.include? sname
#       sch = School.new
#       sch.username = sname
#       sch.password = "1"
#       sch.school_name = sname
#       sch.save
#     end
#     sch = School.first(:school_name => sname)
#     tea = Teacher.new
#     tea.name = row[1].gsub(/['　'\s]+/, '')
#     if row[2]
#       tea.subject = row[2].gsub(/['　'\s]+/, '')
#     else
#       tea.subject = "无"
#     end
#     tea.school = sch
#     if row[3]
#       tea.gender = row[3].strip
#     end
#     if row[4]
#       tea.age = row[4].to_i
#     end
#     tea.save
#   end
# end
