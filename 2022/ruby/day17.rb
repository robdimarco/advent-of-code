def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

class State
  WIDTH = 7
  ROCKS = [
    [[0,0], [1,0], [2,0], [3,0]],
    [[1,0], [0,1], [1,1], [1,2], [2,1]],
    [[0,0], [1,0], [2,0], [2,1], [2,2]],
    [[0,0], [0,1], [0,2], [0,3]],
    [[0,0], [1,0], [0,1], [1,1]]
  ]
  attr_reader :rocks, :gusts, :gust_idx, :current_stack, :current_rock

  def initialize(gusts)
    @gusts = gusts
    @gust_idx = 0
    @rocks = 0
    @current_stack = {}
    next_rock
  end

  def transform(dx, dy)
    @current_rock.map {|(x,y)| [x+dx, y+dy]}
  end

  def height
    # binding.break if @current_stack.size > 0
    @current_stack.any? ? (@current_stack.keys.map(&:last).max + 1) : 0
  end
  
  def apply_gust
    # binding.break if current_rock.size > 4

    dx = @gusts[@gust_idx % @gusts.size] == '<' ? -1 : 1
    pos = transform(dx, 0)
    @current_rock = pos if valid?(pos)
    @gust_idx += 1
  end

  def drop
    pos = transform(0, -1)

    if valid?(pos)
      @current_rock = pos
    else
      @current_rock.each {|p| @current_stack[p] = @rocks}
      next_rock
    end
  end
  
  def valid?(pos)
    pos.none? do |(x,y)|
      x < 0 || x >= WIDTH || y < 0 || (@current_stack.keys & pos).any?
    end
  end

  def next_rock
    @current_rock = ROCKS[@rocks % ROCKS.size]
    @current_rock = transform(2, height + 3)
    @rocks += 1
  end

  def move
    apply_gust
    drop
    clean
  end

  def clean
    return if current_stack.size < 5
    heights = (0..WIDTH).map {|p| current_stack.keys.select {|(x,_)| x == p}.map(&:last).max }
    current_stack.keys.each do |(x,y)|
      h = heights[x]
      current_stack.delete([x,y]) if h - y > 100
    end
  end

  def dump
    puts '+-------+'
    (0..height + 5).to_a.reverse.each do |y|
      print '|'      
      (0...WIDTH).each do |x|
        if current_stack[[x,y]]
          print '#'
        elsif current_rock.include?([x,y])
          print '@'
        else
          print '.'
        end
      end
      puts '|'
    end
    puts '+-------+'
  end
end

def part1(input, limit: 2022)
  state = State.new(input.strip.chars)
  while state.rocks <= limit do
    state.move 
    # puts "ht: #{state.height} r: #{state.rocks}" if state.rocks % 100 == 0
  end
  # state.dump
  state.height
end

def part2(input)
end

# assert_equal(1, part1(SAMPLE, limit: 1))
# assert_equal(4, part1(SAMPLE, limit: 2))
# assert_equal(6, part1(SAMPLE, limit: 3))
# assert_equal(7, part1(SAMPLE, limit: 4))
# assert_equal(9, part1(SAMPLE, limit: 5))
# assert_equal(10, part1(SAMPLE, limit: 6))
# assert_equal(13, part1(SAMPLE, limit: 7))
# assert_equal(15, part1(SAMPLE, limit: 8))
# assert_equal(17, part1(SAMPLE, limit: 9))
# assert_equal(17, part1(SAMPLE, limit: 10))
# assert_equal(18, part1(SAMPLE, limit: 11))
# assert_equal(18, part1(SAMPLE, limit: 20))
# assert_equal(3068, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"
# assert_equal(0, part2(SAMPLE))
# puts "Part 2: #{part2(DATA)}"