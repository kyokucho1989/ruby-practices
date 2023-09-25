#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(shots)
    @frames = []
    while shots.size > 3
      frame = if shots[0] == 'X'
                shots.shift
              else
                shots.shift(2)
              end
      @frames << Frame.new(*frame)
    end
    frame = shots.shift(shots.size)
    @frames << Frame.new(*frame)
  end

  def total_score
    compute_shot_score + compute_spare_bonus + compute_strike_bonus
  end

  private

  def compute_shot_score
    pin = 0
    @frames.each do |frame|
      pin += frame.frame_score
    end
    pin
  end

  def compute_spare_bonus
    spare_bonus = 0
    frames_except_last = @frames[0..-2]
    frames_except_last.each_with_index do |frame, i|
      spare_bonus += @frames[i + 1].first_shot.score if frame.spare?
    end
    spare_bonus
  end

  def compute_strike_bonus
    strike_bonus = 0
    frames_except_last = @frames[0..-2]
    frames_except_last.each_with_index do |frame, i|
      next unless frame.strike?

      strike_bonus += @frames[i + 1].first_shot.score
      strike_bonus += if @frames[i + 1].strike? && i < 8
                        @frames[i + 2].first_shot.score
                      else
                        @frames[i + 1].second_shot.score
                      end
    end
    strike_bonus
  end
end

argvs = ARGV.first.split(',')
shots = argvs.map do |shot|
  shot == 'X' ? shot : shot.to_i
end

game = Game.new(shots)
puts game.total_score
