require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = 0, third_mark = 0)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def frame_score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score != 10 && ( @first_shot.score + @second_shot.score == 10 )
  end
end

frame1 = Frame.new(1,3)
frame2 = Frame.new(7,3)
p frame1.frame_score
p frame1.spare?

p frame2.frame_score
p frame2.spare?
