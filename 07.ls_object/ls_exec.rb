#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls_option'
require_relative 'ls_file'
require_relative 'ls_command'

opt = OptionParser.new
option_existence = { a_option: false, r_option: false, l_option: false }
opt.on('-a') { |_flag| option_existence[:a_option] = true }
opt.on('-r') { |_flag| option_existence[:r_option] = true }
opt.on('-l') { |_flag| option_existence[:l_option] = true }
opt.parse!(ARGV)

option = LsOption.new(option_existence)
ls = LsCommand.new(option)
ls.exec(option)
