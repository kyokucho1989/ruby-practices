# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  TOTAL_PINS_IN_ONE_FRAME = 10
  def initialize(first_mark, second_mark = 0, third_mark = 0)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def frame_score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == TOTAL_PINS_IN_ONE_FRAME
  end

  def spare?
    @first_shot.score != TOTAL_PINS_IN_ONE_FRAME && (@first_shot.score + @second_shot.score == TOTAL_PINS_IN_ONE_FRAME)
  end
end
