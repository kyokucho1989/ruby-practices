#!/usr/bin/env ruby
require 'date'
require 'optparse'
opt = OptionParser.new
month = Date.today.month
year = Date.today.year
opt.on('-m [val]') {|m| month = m.to_i }
opt.on('-y [val]') {|y| 
  if y == nil
    year = Date.today.year
  else
    year = y.to_i
  end 
}

opt.parse!(ARGV)

day_start = Date.new(year,month,1)
day_end = Date.new(year,month,-1)
days = [*day_start.day..day_end.day]

days_to_shift = day_start.wday + 1
disp_days = days
days_to_shift.times{
  disp_days = days.unshift("")
}

weekdays = ["日","月","火","水","木","金","土"]
puts sprintf("      %d月 %d", month,year)
print sprintf("%s " * weekdays.length, *weekdays)
disp_days.each_with_index {|day,i|
  if month == Date.today.month && day == Date.today.day
    print "\e[31m"
  else
    print "\e[0m"
  end
  print sprintf("%2s ",day)
  if i % 7 == 0
    puts ""
  end
  print "\e[0m"
}
puts ""
