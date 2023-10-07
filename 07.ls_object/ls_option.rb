# frozen_string_literal: true

class LsOption
  attr_reader :a_option, :l_option, :r_option

  def initialize
    opt = OptionParser.new
    @a_option = false
    @r_option = false
    @l_option = false
    opt.on('-a') { |_flag| @a_option = true }
    opt.on('-r') { |_flag| @r_option = true }
    opt.on('-l') { |_flag| @l_option = true }
    opt.parse!(ARGV)
  end
end
