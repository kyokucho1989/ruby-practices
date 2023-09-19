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
    @frames << Frame.new(*frame)
  end

  def total_score
    killed_pin_count + compute_spare_bonus + compute_strike_bonus
  end

  def killed_pin_count
    pin = 0
    @frames.each do |frame|
      pin += frame.frame_score
    end
    pin
  end

  def compute_spare_bonus
    spare_bonus = 0
    frames_except_last = @frames[0..-2]
    frames_except_last.each_with_index do |frame,i|
      if frame.spare?
        spare_bonus += @frames[i+1].first_shot.score
      end
    end
    spare_bonus
  end

  def compute_strike_bonus
    strike_bonus = 0
    frames_except_last = @frames[0..-2]
    frames_except_last.each_with_index do |frame,i|
      if frame.strike?
        strike_bonus += @frames[i+1].first_shot.score
        if @frames[i+1].strike? && i < 8
          strike_bonus += @frames[i+2].first_shot.score
        else
          strike_bonus += @frames[i+1].second_shot.score
        end
      end
    end
    strike_bonus
  end

end

argvs = ARGV.first.split(',')
shots = argvs.map do |shot|
  shot == 'X' ? shot : shot.to_i
end
# shots = [6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X','X','X','X']
game = Game.new(shots)
kill_counts = game.killed_pin_count
spare_bonus = game.compute_spare_bonus
strike_bonus = game.compute_strike_bonus
total_score = game.total_score
puts "倒した本数: #{kill_counts} / スペアボーナス : #{spare_bonus} / ストライクボーナス: #{strike_bonus} "
puts "トータルスコア #{total_score}"
# game.frames[0].first_shot.mark
