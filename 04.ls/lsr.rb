#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opt = OptionParser.new
file_names = Dir.glob('*')

opt.on('-a [val]') do |_flag|
  file_names = Dir.glob('.*') + file_names
end
opt.parse!(ARGV)

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
