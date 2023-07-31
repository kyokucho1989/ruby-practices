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
days_to_shift = day_start.wday + 3

weekdays = %w[日 月 火 水 木 金 土]
puts "      #{month}月 #{year}"
weekdays.each { |day| print day.ljust(2) }
puts ''
print '  ' * days_to_shift
(day_start..day_end).each do |date|
  if month == Date.today.month && date.day == Date.today.day && year == Date.today.year
    print "\e[30m\e[47m"
  else
    print "\e[0m"
  end
  print "#{date.day.to_s.rjust(2)}\e[0m "
  puts '' if date.saturday?
  print "\e[0m"
end
puts ''
