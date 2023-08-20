#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

TOTAL_BLOCKS = 0
BLOCK_SIZE = 512
BLOCK_UNITS = 8

def get_ftype(fstat)
  type = fstat.ftype
  if type == 'directory'
    'd'
  elsif type == 'link'
    'l'
  else
    '-'
  end
end

def comupute_total_blocksize(files)
  selected_files = files.select { |a| a[:mode] == '-' }
  block_sizes = selected_files.map { |file| (file[:size].to_i / (BLOCK_SIZE * BLOCK_UNITS).to_f).ceil * BLOCK_UNITS }
  block_sizes.sum
end

def convert_mode_number_to_symbol(number)
  cut_numbers = number[-3, 3].chars
  permission_chars = ''
  cut_numbers.each do |n|
    permission_chars += (0..2).map { |i| (n.to_i & 0b100 >> i).zero? ? '-' : 'rwx'[i] }.join
  end
  permission_chars
end

def get_timestamp(fstat)
  date = fstat.ctime
  if Date.today.year == date.year
    date.strftime('%_m %_d %R')
  else
    date.strftime('%_m %_d  %Y')
  end
end

def get_matrix_type_files(files, file_names, display_col_size)
  fold_point = (file_names.size / display_col_size.to_f).ceil
  matrix_type_files = files.each_slice(fold_point).to_a
  num = fold_point - matrix_type_files.last.size
  num.times do
    matrix_type_files.last << { name: '' }
  end
  matrix_type_files
end

def display_as_transposed_matrix(matrix_type_files)
  disp_file_names = matrix_type_files.transpose
  disp_file_names.each do |disp_files|
    disp_files.each do |file|
      print file[:name].ljust(40)
    end
    puts ''
  end
end

def display_with_l_option(files, total_blocksize)
  puts "total #{total_blocksize}"
  files.each do |file|
    print file[:mode] + file[:permission] + file[:hardlink].rjust(5) + file[:owner].rjust(10)
    print "#{file[:group].rjust(7)}#{file[:size].rjust(6)}#{file[:timestamp].rjust(12)} #{file[:name].ljust(5)}#{file[:readlink]}"
    puts ''
  end
end

opt = OptionParser.new
arg = ['*']
reverse_flag = false
l_flag = false

# opt.on('-a [val]') do |_flag|
#   arg << File::FNM_DOTMATCH
# end

# opt.on('-r [val]') do |_flag|
#   reverse_flag = true
# end

opt.on('-l [val]') do |_flag|
  l_flag = true
end
opt.parse!(ARGV)
file_names = Dir.glob(*arg).then { |result| reverse_flag ? result.reverse : result }

first_file_name = file_names[0]
permission_numbers = File.stat(first_file_name).mode.to_s(8)

display_col_size = 3

if l_flag
  files = file_names.map do |name|
    hash = { name: }
    if FileTest.symlink?(name)
      file_stat = File.lstat(name)
      hash[:readlink] = " -> #{File.readlink(name)}"
    else
      file_stat = File.stat(name)
      hash[:readlink] = ''
    end
    permission_numbers = file_stat.mode.to_s(8)
    permission_chars = convert_mode_number_to_symbol(permission_numbers)
    hash[:permission] = permission_chars
    hash[:mode] = get_ftype(file_stat)
    hash[:hardlink] = file_stat.nlink.to_s
    u_id = file_stat.uid
    hash[:owner] = Etc.getpwuid(u_id).name
    g_id = file_stat.gid
    hash[:group] = Etc.getgrgid(g_id).name
    hash[:size] = file_stat.size.to_s
    hash[:timestamp] = get_timestamp(file_stat)
    hash
  end

  total_blocksize = comupute_total_blocksize(files)
  display_with_l_option(files, total_blocksize)

else
  files = file_names.map do |name|
    { name: }
  end
  matrix_type_files = get_matrix_type_files(files, file_names, display_col_size)
  display_as_transposed_matrix(matrix_type_files)
end
