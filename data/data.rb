# encoding: utf-8

require_relative '../db'
require 'rubygems'
require 'bundler/setup'
require 'roo'
require 'pry'

@schools = []

xls = Roo::Excel.new("3.xls")

xls.each_with_pagename do |name, sheet|
  (1..(sheet.last_row)).each do |rnum|
      unless @schools.include? sheet.row(rnum)[0].strip
        @schools.push sheet.row(rnum)[0].strip
      end
  end
end

binding.pry
