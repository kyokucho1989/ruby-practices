#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def display_flag(has_c_option, has_l_option, has_w_option)
  has_no_options = !(has_w_option || has_c_option || has_l_option)
  has_c_option ||= has_no_options
  has_l_option ||= has_no_options
  has_w_option ||= has_no_options
  [has_c_option, has_l_option, has_w_option]
end

def compute_file_size(str)
  row_size =  str.count("\n")
  word_size = str.split(' ').size
  byte_size = str.size
  [row_size, word_size, byte_size]
end

def display_file_data(has_c_option, has_l_option, has_w_option, file_name = '', **size)
  row_size = size[:row_size]
  word_size = size[:word_size]
  byte_size = size[:byte_size]
  display = ''
  display += row_size.to_s.rjust(8) if has_l_option
  display += word_size.to_s.rjust(8) if has_w_option
  display += byte_size.to_s.rjust(8) if has_c_option
  display += " #{file_name}"
  puts display
end

def generate_file_data_one_line(has_c_option, has_l_option, has_w_option, files)
  file_size_total = { row: 0, word: 0, byte: 0 }
  files.each do |file|
    str = File.read(file)
    row_size, word_size, byte_size = compute_file_size(str)
    disp_file_data(has_c_option, has_l_option, has_w_option, file, row_size:, word_size:, byte_size:)
    file_size_total[:row] += row_size
    file_size_total[:word] += word_size
    file_size_total[:byte] += byte_size
  end
  row_size = file_size_total[:row]
  word_size = file_size_total[:word]
  byte_size = file_size_total[:byte]
  disp_file_data(has_c_option, has_l_option, has_w_option, 'total', row_size:, word_size:, byte_size:) if files.size > 1
end

def main
  opt = OptionParser.new
  has_c_option = false
  has_l_option = false
  has_w_option = false
  opt.on('-c') { |_flag| has_c_option = true }
  opt.on('-l') { |_flag| has_l_option = true }
  opt.on('-w') { |_flag| has_w_option = true }
  opt.parse!(ARGV)
  has_c_option, has_l_option, has_w_option = display_flag(has_c_option, has_l_option, has_w_option)
  files = ARGV

  if files.size.positive?
    generate_file_data_one_line(has_c_option, has_l_option, has_w_option, files)

  else
    while (line = gets(nil))
      row_size, word_size, byte_size = compute_file_size(line)
      display_file_data(has_c_option, has_l_option, has_w_option, row_size:, word_size:, byte_size:)
    end
  end
end

main
