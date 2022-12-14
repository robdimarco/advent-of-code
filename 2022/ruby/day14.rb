def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'algorithms'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
TEXT

def part1(input)
  map = {}
  plots = input.lines.each_with_object({}) do |line, hsh|
    tokens = line.split(' -> ').map {|t| t.split(',').map(&:to_i)}
    last_token = tokens.shift 
    while tokens.any?
      next_token = tokens.shift
      # puts "Comparing #{next_token.inspect} with #{last_token.inspect}"
      if next_token[0] == last_token[0]
        s = [last_token[1], next_token[1]].sort
        (s[0]..s[1]).each do |y|
          hsh[[next_token[0], y]] = true
        end
      else
        s = [last_token[0], next_token[0]].sort
        (s[0]..s[1]).each do |x|
          hsh[[x, next_token[1]]] = true
        end
      end
      last_token = next_token
    end
  end
  max_y = plots.keys.map {|k| k[1]}.max
  # puts "Plots #{plots.inspect} : max = #{max_y}"
  units = 0
  loop do
    pos = [500, 0]
    moving = true
    while moving do
      # puts "Units #{units} pos = #{pos.inspect}"
      return units if pos[1] > max_y  
      
      if plots[[pos[0], pos[1] + 1]].nil?
        # plots[[pos[0], pos[1] + 1]] = true
        pos = [pos[0], pos[1] + 1]
      elsif plots[[pos[0] - 1, pos[1] + 1]].nil?
        # plots[[pos[0] - 1, pos[1] + 1]] = true
        pos = [pos[0] - 1, pos[1] + 1]
      elsif plots[[pos[0] + 1, pos[1] + 1]].nil?
        # plots[[pos[0] + 1, pos[1] + 1]] = true
        pos = [pos[0] + 1, pos[1] + 1]
      else
        plots[pos] = true
        moving = false
        units += 1
      end
    end
  end

  units
end

assert_equal(24, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

def part2(input)
  map = {}
  plots = input.lines.each_with_object({}) do |line, hsh|
    tokens = line.split(' -> ').map {|t| t.split(',').map(&:to_i)}
    last_token = tokens.shift 
    while tokens.any?
      next_token = tokens.shift
      # puts "Comparing #{next_token.inspect} with #{last_token.inspect}"
      if next_token[0] == last_token[0]
        s = [last_token[1], next_token[1]].sort
        (s[0]..s[1]).each do |y|
          hsh[[next_token[0], y]] = true
        end
      else
        s = [last_token[0], next_token[0]].sort
        (s[0]..s[1]).each do |x|
          hsh[[x, next_token[1]]] = true
        end
      end
      last_token = next_token
    end
  end
  max_y = plots.keys.map {|k| k[1]}.max + 1
  # puts "Plots #{plots.inspect} : max = #{max_y}"
  units = 0
  loop do
    pos = [500, 0]
    moving = true
    while moving do

      # puts "Units #{units} pos = #{pos.inspect}"
      # return -1 if units == 24
      if plots[[pos[0], pos[1] + 1]].nil? && pos[1] < max_y
        # plots[[pos[0], pos[1] + 1]] = true
        pos = [pos[0], pos[1] + 1]
      elsif plots[[pos[0] - 1, pos[1] + 1]].nil? && pos[1] < max_y
        # plots[[pos[0] - 1, pos[1] + 1]] = true
        pos = [pos[0] - 1, pos[1] + 1]
      elsif plots[[pos[0] + 1, pos[1] + 1]].nil? && pos[1] < max_y
        # plots[[pos[0] + 1, pos[1] + 1]] = true
        pos = [pos[0] + 1, pos[1] + 1]
      else
        plots[pos] = true
        moving = false
        
        units += 1
        return units if pos == [500, 0]
      end
    end
  end

  units
end

assert_equal(93, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"