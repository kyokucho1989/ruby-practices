#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'
opt = OptionParser.new
month = Date.today.month
year = Date.today.year
opt.on('-m [val]') { |m| month = m.to_i }
opt.on('-y [val]') { |y| year = y.to_i }
opt.parse!(ARGV)

day_start = Date.new(year, month, 1)
day_end = Date.new(year, month, -1)
days_to_shift = day_start.wday

weekdays = %w[日 月 火 水 木 金 土]
puts "      #{month}月 #{year}"
weekdays.each { |day| print day.ljust(2) }
puts ''
print '   ' * days_to_shift
(day_start..day_end).each do |date|
  Date.today == date ? (print "\e[7m") : (print "\e[0m")
  print "#{date.day.to_s.rjust(2)}\e[0m "
  puts '' if date.saturday?
end
puts ''
