#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game

  attr_reader :frames

  def initialize(shots)
    @frames = []
    while shots.size > 3
      if shots[0] == 'X'
        frame = shots.shift
      else
        frame = shots.shift(2)
      end
      @frames << Frame.new(*frame)

    end
    frame = shots.shift(shots.size)
    frames << frame
    # puts " frames:#{frames} "
  end

end
# shots = [6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X','X','X','X']
game = Game.new(shots)
# game.frames[0].first_shot.mark
