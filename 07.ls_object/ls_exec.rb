#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls_option'
require_relative 'ls_file'
require_relative 'ls_command'

option = LsOption.new
ls = LsCommand.new(option)
ls.display_file_data(option)
