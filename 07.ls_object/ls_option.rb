# frozen_string_literal: true

require 'optparse'

class LsOption
  attr_reader :a_option, :l_option, :r_option

  def initialize(argv)
    opt = OptionParser.new
    option_existence = { a_option: false, r_option: false, l_option: false }
    opt.on('-a') { |_flag| option_existence[:a_option] = true }
    opt.on('-r') { |_flag| option_existence[:r_option] = true }
    opt.on('-l') { |_flag| option_existence[:l_option] = true }
    opt.parse!(argv)

    @a_option = option_existence[:a_option]
    @r_option = option_existence[:r_option]
    @l_option = option_existence[:l_option]
  end
end
