#!/usr/bin/env ruby
# frozen_string_literal: true

kill_counts = ARGV.first.split(',')

kill_counts.each_with_index do |n, i|
  n == 'X' ? kill_counts[i] = n : kill_counts[i] = n.to_i
end

kill_counts_x_to_ten = kill_counts.map do |n|
  n == 'X' ? 10 : n
end

# kill_counts =           [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, "X", 9, 1, 8, 0, "X", "X", 1, 8]
# kill_counts_x_to_ten =  [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, 10, 9, 1, 8, 0, 10, 10, 1, 8]
# formatted_counts =      [6, 3, 9, 0, 0, 3, 8, 2, 7, 3, "X", 0, 9, 1, 8, 0, "X", 0, "X", 0, 1, 8, 0, 0]
# spear_flag =>           [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

# ストライクの結果表示
strike_flag = []
strike_flag = kill_counts.map do |n|
  n == 'X' ? 1 : 0
end

strike_shift_array1 = kill_counts_x_to_ten[1..].push(0)
strike_shift_array2 = kill_counts_x_to_ten[2..].push(0).push(0)
strike_bonus_array = strike_shift_array1.zip(strike_shift_array2).map { |a, b| a + b }
strike_bonus_array2 = strike_bonus_array.zip(strike_flag).map { |a, b| a * b }
# 10フレーム目のボーナスはなし
strike_bonus_array2[-3..] = [0, 0, 0]
strike_bonus = strike_bonus_array2.sum

# スペアのスコア計算

# ストライクをとったレーンの2投目に0を付け足す
formatted_counts = kill_counts.dup
formatted_counts.each_index do |i|
  if formatted_counts[i] == 'X'
    formatted_counts.insert(i+1, 0)
  end
end
formatted_counts.push 0, 0

spare_flag = [0]
formatted_counts.each_slice(2) do |num|
  if num.include?('X')
    spare_flag << [0, 0]
  elsif num.sum == 10
    spare_flag << [0, 1]
  else
    spare_flag << [0, 0]
  end
end

spare_flag.flatten!
spare_flag[-5] = 0
formatted_counts_x_to_ten = formatted_counts.map do |n|
  n == 'X' ? 10 : n
end

spare_bounus_array = formatted_counts_x_to_ten.zip(spare_flag).map { |a, b| a * b }
spare_bounus = spare_bounus_array.sum

# 倒したピンの本数の計算
kill_counts_score = kill_counts_x_to_ten.sum

total_score = kill_counts_score + spare_bounus + strike_bonus
# 結果表示
p total_score
