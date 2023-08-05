#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
file_names = Dir.glob('*')

display_col_size = 3
files = file_names.map do |name|
  { name: }
end

fold_point = file_names.size / display_col_size

matrix_type_files = []
files.each_slice(fold_point) do |separated_files|
  matrix_type_files << separated_files
end

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
