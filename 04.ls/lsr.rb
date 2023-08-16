#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
arg = ['*']
reverse_flag = false
# opt.on('-a [val]') do |_flag|
#   arg << File::FNM_DOTMATCH
# end

opt.on('-r [val]') do |_flag|
  reverse_flag = true
end
opt.parse!(ARGV)
file_names = Dir.glob(*arg).then { |result| reverse_flag ? result.reverse : result }
display_col_size = 3
files = file_names.map do |name|
  { name: }
end

fold_point = (file_names.size / display_col_size.to_f).ceil

matrix_type_files = files.each_slice(fold_point).to_a

num = fold_point - matrix_type_files.last.size
num.times do
  matrix_type_files.last << { name: '' }
end

disp_file_names = matrix_type_files.transpose
disp_file_names.each do |disp_files|
  disp_files.each do |file|
    print file[:name].ljust(40)
  end
  puts ''
end
