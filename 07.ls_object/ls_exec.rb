#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'ls_file'
require_relative 'ls_command'

ls = LsCommand.new(ARGV)
ls.exec
