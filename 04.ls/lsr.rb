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
  permission_chars += cut_numbers.map do |n|
    (0..2).map { |i| (n.to_i & 0b100 >> i).zero? ? '-' : 'rwx'[i] }.join
  end.join
  permission_chars
end

def get_timestamp(fstat)
  date = fstat.ctime
  date_arg = Date.today.year == date.year ? '%_m %_d %R' : '%_m %_d  %Y'
  date.strftime(date_arg)
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

def display_multiple_columns(matrix_type_files)
  disp_file_names = matrix_type_files.transpose
  disp_file_names.each do |disp_files|
    disp_files.each do |file|
      print file[:name].ljust(40)
    end
    puts ''
  end
end

def display_detailed_information(files, total_blocksize)
  puts "total #{total_blocksize}"
  files.each do |file|
    print file[:mode] + file[:permission] + file[:hardlink].rjust(5) + file[:owner].rjust(10)
    print "#{file[:group].rjust(7)}#{file[:size].rjust(6)}#{file[:timestamp].rjust(12)} #{file[:name].ljust(5)}#{file[:readlink]}"
    puts ''
  end
end

def get_file_detail_data(file_names)
  file_names.map do |name|
    hash = { name: }
    file_stat = FileTest.symlink?(name) ? File.lstat(name) : File.stat(name)
    hash[:readlink] = FileTest.symlink?(name) ? " -> #{File.readlink(name)}" : ''
    permission_numbers = file_stat.mode.to_s(8)
    hash[:permission] = convert_mode_number_to_symbol(permission_numbers)
    hash[:mode] = get_ftype(file_stat)
    hash[:hardlink] = file_stat.nlink.to_s
    hash[:owner] = Etc.getpwuid(file_stat.uid).name
    hash[:group] = Etc.getgrgid(file_stat.gid).name
    hash[:size] = file_stat.size.to_s
    hash[:timestamp] = get_timestamp(file_stat)
    hash
  end
end

def display_file_data(l_flag, file_names, display_col_size)
  if l_flag
    files = get_file_detail_data(file_names)
    total_blocksize = comupute_total_blocksize(files)
    display_detailed_information(files, total_blocksize)
  else
    files = file_names.map { |name| { name: } }
    matrix_type_files = get_matrix_type_files(files, file_names, display_col_size)
    display_multiple_columns(matrix_type_files)
  end
end

def main
  opt = OptionParser.new
  arg = ['*']
  reverse_flag = false
  l_flag = false
  opt.on('-a') do |_flag|
    arg << File::FNM_DOTMATCH
  end

  opt.on('-r') do |_flag|
    reverse_flag = true
  end

  opt.on('-l') do |_flag|
    l_flag = true
  end
  opt.parse!(ARGV)
  file_names = Dir.glob(*arg).then { |result| reverse_flag ? result.reverse : result }
  display_col_size = 3

  display_file_data(l_flag, file_names, display_col_size)
end

main
