#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require_relative 'ls_option'
require_relative 'ls_file'
TOTAL_BLOCKS = 0
BLOCK_SIZE = 512
BLOCK_UNITS = 8
DISPALY_COL_SIZE = 3

class LsCommand
  def initialize(option)
    @option = option
    @file_names = file_names(option)
  end

  def exec(option)
    if option.l_option
      total_blocksize = comupute_total_blocksize
      display_detailed_information(total_blocksize)
    else
      files = @file_names.map { |name| { name: } }
      matrix_type_files = matrix_type_files(files)
      display_multiple_columns(matrix_type_files)
    end
  end

  private

  def files
    @files ||= @file_names.map do |name|
      LsFile.new(name, @option)
    end
  end

  def file_names(option)
    arg = ['*']
    arg << File::FNM_DOTMATCH if option.a_option
    Dir.glob(*arg).then { |result| @option.r_option ? result.reverse : result }
  end

  def comupute_total_blocksize
    selected_files = files.select { |a| a.mode == '-' }
    block_sizes = selected_files.map { |file| (file.size.to_i / (BLOCK_SIZE * BLOCK_UNITS).to_f).ceil * BLOCK_UNITS }
    block_sizes.sum
  end

  def matrix_type_files(files)
    fold_point = (@file_names.size / DISPALY_COL_SIZE.to_f).ceil
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

  def display_detailed_information(total_blocksize)
    puts "total #{total_blocksize}"
    files.each do |file|
      print file.mode + file.permission + file.hardlink.rjust(5) + file.owner.rjust(10)
      print "#{file.group.rjust(7)}#{file.size.rjust(6)}#{file.timestamp.rjust(12)} #{file.name.ljust(5)}#{file.readlink}"
      puts ''
    end
  end
end
