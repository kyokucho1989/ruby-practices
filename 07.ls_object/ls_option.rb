# frozen_string_literal: true

class LsOption
  attr_reader :a_option, :l_option, :r_option

  def initialize(options)
    @a_option = options[:a_option]
    @r_option = options[:r_option]
    @l_option = options[:l_option]
  end
end
