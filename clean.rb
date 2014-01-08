# encoding: utf-8

require_relative 'db'
require 'rubygems'
require 'bundler/setup'

teas = Teacher.all

teas.each do |tea|
  tea.name = tea.name.gsub(/['　'\s]+/, '')
  tea.save
end
