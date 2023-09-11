#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def booleans_display_or_hide
  opt = OptionParser.new
  options = { has_c_option: false, has_l_option: false, has_w_option: false }
  opt.on('-c') { |_flag| options[:has_c_option] = true }
  opt.on('-l') { |_flag| options[:has_l_option] = true }
  opt.on('-w') { |_flag| options[:has_w_option] = true }
  opt.parse!(ARGV)
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
  { row_size:, word_size:, byte_size: }
end

def display_file_data(display_set, size, file_name = '')
  row_size = size[:row_size]
  word_size = size[:word_size]
  byte_size = size[:byte_size]
  display = ''
  display += row_size.to_s.rjust(8) if display_set[:is_display_lines]
  display += word_size.to_s.rjust(8) if display_set[:is_display_words]
  display += byte_size.to_s.rjust(8) if display_set[:is_display_bytes]
  display += " #{file_name}" if !file_name.empty?
  puts display
end

def display_file_data_one_line(display_set, files)
  file_size_total = { row_size: 0, word_size: 0, byte_size: 0 }
  files.each do |file|
    str = File.read(file)
    size_hash = compute_file_size(str)
    display_file_data(display_set, size_hash, file)
    file_size_total[:row_size] += size_hash[:row_size]
    file_size_total[:word_size] += size_hash[:word_size]
    file_size_total[:byte_size] += size_hash[:byte_size]
  end
  display_file_data(display_set, file_size_total, 'total') if files.size > 1
end

def main
  booleans = booleans_display_or_hide
  display_set = { is_display_bytes: booleans[0], is_display_lines: booleans[1], is_display_words: booleans[2] }
  files = ARGV

  if files.size.positive?
    display_file_data_one_line(display_set, files)
  else
    while (line = gets(nil))
      size_hash = compute_file_size(line)
      display_file_data(display_set, size_hash)
    end
  end
end

main
