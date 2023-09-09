#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def display_flag(c_flag, l_flag, w_flag)
  normal_flag = !(w_flag || c_flag || l_flag)
  c_flag ||= normal_flag
  l_flag ||= normal_flag
  w_flag ||= normal_flag
  [c_flag, l_flag, w_flag]
end

def compute_file_size(str)
  row_size =  str.count("\n")
  word_size = str.split(' ').size
  byte_size = str.size
  [row_size, word_size, byte_size]
end

def display_file_data(c_flag, l_flag, w_flag, file_name = '', **size)
  row_size = size[:row_size]
  word_size = size[:word_size]
  byte_size = size[:byte_size]
  display = ''
  display += row_size.to_s.rjust(8) if l_flag
  display += word_size.to_s.rjust(8) if w_flag
  display += byte_size.to_s.rjust(8) if c_flag
  display += " #{file_name}"
  puts display
end

def generate_file_data_one_line(c_flag, l_flag, w_flag, file_list)
  file_size_total = { row: 0, word: 0, byte: 0 }
  file_list.each do |file|
    str = File.read(file)
    row_size, word_size, byte_size = compute_file_size(str)
    disp_file_data(c_flag, l_flag, w_flag, file, row_size:, word_size:, byte_size:)
    file_size_total[:row] += row_size
    file_size_total[:word] += word_size
    file_size_total[:byte] += byte_size
  end
  row_size = file_size_total[:row]
  word_size = file_size_total[:word]
  byte_size = file_size_total[:byte]
  disp_file_data(c_flag, l_flag, w_flag, 'total', row_size:, word_size:, byte_size:) if file_list.size > 1
end

def main
  opt = OptionParser.new
  c_flag = false
  l_flag = false
  w_flag = false
  opt.on('-c') { |_flag| c_flag = true }
  opt.on('-l') { |_flag| l_flag = true }
  opt.on('-w') { |_flag| w_flag = true }
  opt.parse!(ARGV)
  c_flag, l_flag, w_flag = display_flag(c_flag, l_flag, w_flag)
  file_list = ARGV

  if file_list.size.positive?
    generate_file_data_one_line(c_flag, l_flag, w_flag, file_list)

  else
    while (line = gets(nil))
      row_size, word_size, byte_size = calc_file_size(line)
      display_file_data(c_flag, l_flag, w_flag, row_size:, word_size:, byte_size:)
    end
  end
end

main
