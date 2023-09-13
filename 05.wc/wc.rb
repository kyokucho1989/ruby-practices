#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def build_display_status_from_options
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
  { is_display_bytes:, is_display_lines:, is_display_words: }
end

def compute_file_sizes(str)
  row_size =  str.count("\n")
  word_size = str.split(' ').size
  byte_size = str.size
  { row_size:, word_size:, byte_size: }
end

def display_file_data(display_status, file_sizes, file_name = '')
  row_size = file_sizes[:row_size]
  word_size = file_sizes[:word_size]
  byte_size = file_sizes[:byte_size]
  display = ''
  display += row_size.to_s.rjust(8) if display_status[:is_display_lines]
  display += word_size.to_s.rjust(8) if display_status[:is_display_words]
  display += byte_size.to_s.rjust(8) if display_status[:is_display_bytes]
  display += " #{file_name}" if !file_name.empty?
  puts display
end

def display_file_data_one_line(display_status, file_sizes_with_names, file_sizes_total)
  file_sizes_with_names.each do |file|
    file_sizes = file.slice(:row_size, :word_size, :byte_size)
    display_file_data(display_status, file_sizes, file[:file_name])
  end
  display_file_data(display_status, file_sizes_total, 'total') if file_sizes_with_names.size > 1
end

def compute_file_sizes_total(file_sizes_with_names)
  file_sizes_total = { row_size: 0, word_size: 0, byte_size: 0 }
  file_sizes_with_names.each do |file|
    file_sizes_total[:row_size] += file[:row_size]
    file_sizes_total[:word_size] += file[:word_size]
    file_sizes_total[:byte_size] += file[:byte_size]
  end
  file_sizes_total
end

def build_file_sizes_with_names(files)
  files.map do |file|
    file_names = { file_name: file }
    str = File.read(file)
    file_names.merge!(compute_file_sizes(str))
  end
end

def main
  display_status = build_display_status_from_options
  files = ARGV
  file_sizes_with_names = build_file_sizes_with_names(files)
  file_sizes_total = compute_file_sizes_total(file_sizes_with_names)
  if files.size.positive?
    display_file_data_one_line(display_status, file_sizes_with_names, file_sizes_total)
  else
    while (line = gets(nil))
      file_sizes = compute_file_sizes(line)
      display_file_data(display_status, file_sizes)
    end
  end
end

main
