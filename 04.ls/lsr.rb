#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

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
  total_blocks = 0
  block_size = 512
  block_units = 8
  file_cumputes = files.select { |a| a[:mode] == '-' }
  file_cumputes.each do |file|
    total_blocks += (file[:size].to_i / (block_size * block_units).to_f).ceil * block_units
  end
  total_blocks
end

def convert_mode_number_to_symbol(number)
  cut_numbers = number[-3, 3].chars
  permission_chars = ''
  cut_numbers.each do |n|
    permission_chars += (n.to_i & 0b100).zero? ? '-' : 'r'
    permission_chars += (n.to_i & 0b010).zero? ? '-' : 'w'
    permission_chars += (n.to_i & 0b001).zero? ? '-' : 'x'
  end
  permission_chars
end

def get_timestamp(fstat)
  date = fstat.ctime
  if Date.today.year == date.year
    date.strftime("%_m %_d %R")
  else
    date.strftime("%_m %_d  %Y")
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

files = file_names.map do |name|
  
  if !l_flag
    { name: }
  else
    hash = { name: }
    if FileTest.symlink?(name)
      file_stat = File.lstat(name)
      hash[:readlink] = ' -> ' + File.readlink(name)
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
end

if !l_flag
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
else
  puts 'total ' + comupute_total_blocksize(files).to_s
  files.each do |file|
    print file[:mode] + file[:permission] + file[:hardlink].rjust(5) + file[:owner].rjust(10)
    print file[:group].rjust(7) + file[:size].rjust(6) + file[:timestamp].rjust(12) + ' ' + file[:name] + file[:readlink]
    puts ''
  end

end
