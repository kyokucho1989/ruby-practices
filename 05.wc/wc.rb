#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def display_flag(options)
  has_no_options = !(options[:has_c_option] || options[:has_l_option] || options[:has_w_option])
  is_display_bytes = options[:has_c_option] || has_no_options
  is_display_lines = options[:has_l_option] || has_no_options
  is_display_words = options[:has_w_option] || has_no_options
  [is_display_bytes, is_display_lines, is_display_words]
end

def compute_file_size(str)
  row_size =  str.count("\n")
  word_size = str.split(' ').size
  byte_size = str.size
  [row_size, word_size, byte_size]
end

def display_file_data(display_set, file_name = '', **size)
  row_size = size[:row_size]
  word_size = size[:word_size]
  byte_size = size[:byte_size]
  display = ''
  display += row_size.to_s.rjust(8) if display_set[:is_display_lines]
  display += word_size.to_s.rjust(8) if display_set[:is_display_words]
  display += byte_size.to_s.rjust(8) if display_set[:is_display_bytes]
  display += " #{file_name}"
  puts display
end

def generate_file_data_one_line(display_set, files)
  file_size_total = { row: 0, word: 0, byte: 0 }
  files.each do |file|
    str = File.read(file)
    row_size, word_size, byte_size = compute_file_size(str)
    display_file_data(display_set, file, row_size:, word_size:, byte_size:)
    file_size_total[:row] += row_size
    file_size_total[:word] += word_size
    file_size_total[:byte] += byte_size
  end
  row_size = file_size_total[:row]
  word_size = file_size_total[:word]
  byte_size = file_size_total[:byte]
  display_file_data(display_set, 'total', row_size:, word_size:, byte_size:) if files.size > 1
end

def main
  opt = OptionParser.new
  options = { has_c_option: false, has_l_option: false, has_w_option: false}
  opt.on('-c') { |_flag| options[:has_c_option] = true }
  opt.on('-l') { |_flag| options[:has_l_option] = true }
  opt.on('-w') { |_flag| options[:has_w_option] = true }
  opt.parse!(ARGV)
  
  flags = display_flag(options)
  display_set = {is_display_bytes: flags[0], is_display_lines: flags[1], is_display_words: flags[2]} 
  files = ARGV

  if files.size.positive?
    generate_file_data_one_line(display_set, files)
  else
    while (line = gets(nil))
      row_size, word_size, byte_size = compute_file_size(line)
      display_file_data(display_set, row_size:, word_size:, byte_size:)
    end
  end

end

main
