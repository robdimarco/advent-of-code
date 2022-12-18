def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

class RepeatPatternNotice < StandardError
  attr_reader :total
  def initialize(total)
    super("Found #{total} through pattern")
    @total = total
  end
end

class State
  WIDTH = 7
  ROCKS = [
    [[0,0], [1,0], [2,0], [3,0]],
    [[1,0], [0,1], [1,1], [1,2], [2,1]],
    [[0,0], [1,0], [2,0], [2,1], [2,2]],
    [[0,0], [0,1], [0,2], [0,3]],
    [[0,0], [1,0], [0,1], [1,1]]
  ]
  attr_reader :rocks, :gusts, :gust_idx, :current_stack, :current_rock, :uniqs, :limit, :values

  def initialize(gusts, limit, raise_on_loop: false)
    @gusts = gusts
    @gust_idx = 0
    @rocks = 0
    @current_stack = {}
    @uniqs = {}
    @values = {}
    @raise_on_loop = raise_on_loop
    @limit = limit
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
      @values[@rocks] = height
      @current_rock.each {|p| @current_stack[p] = @rocks}
      next_rock
    end
  end
  
  def valid?(pos)
    pos.none? do |(x,y)|
      x < 0 || x >= WIDTH || y < 0 || (@current_stack.keys & pos).any?
    end
  end

  def max_height_indexes
    return [] if @current_stack.empty?
    h = @current_stack.keys.map(&:last).max
    hgts = (0...WIDTH).map do |x| 
      max = @current_stack.keys.map do |n|
        n[0] == x ? n[1] : nil
      end.compact.max.to_i
      h - max
    end    
    # binding.break if @rocks % 1000 == 0

    hgts
  end

  def next_rock
    cache_key = [
      @rocks % ROCKS.size, 
      @gust_idx % gusts.size, 
      max_height_indexes
    ]

    if @uniqs[cache_key]
      last_rocks = @uniqs[cache_key]
      pre_loop_height = @values[last_rocks]
      loop_size = @rocks - last_rocks
      loop_height = @values[@rocks] - @values[last_rocks]

      in_pattern = limit - last_rocks
      iters = in_pattern / loop_size
      extra = in_pattern % loop_size
      total = values[last_rocks + extra + 1] + (iters * loop_height)
      # binding.break

      raise RepeatPatternNotice.new(total) if @raise_on_loop
    end
    @uniqs[cache_key] = @rocks
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
    (current_stack.keys.map{|(_,y)| y}.min..height + 5).to_a.reverse.each do |y|
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

def part1(input, limit: 2022, raise_on_loop: true)
  state = State.new(input.strip.chars, limit, raise_on_loop: raise_on_loop)
  begin
    while state.rocks <= limit do
      state.move 
      # puts "ht: #{state.height} r: #{state.rocks}" if state.rocks % 100 == 0
    end
    state.height
  rescue RepeatPatternNotice => e
    return e.total
  end
end

assert_equal(1, part1(SAMPLE, limit: 1))
assert_equal(4, part1(SAMPLE, limit: 2))
assert_equal(6, part1(SAMPLE, limit: 3))
assert_equal(7, part1(SAMPLE, limit: 4))
assert_equal(9, part1(SAMPLE, limit: 5))
assert_equal(10, part1(SAMPLE, limit: 6))
assert_equal(13, part1(SAMPLE, limit: 7))
assert_equal(15, part1(SAMPLE, limit: 8))
assert_equal(17, part1(SAMPLE, limit: 9))
assert_equal(17, part1(SAMPLE, limit: 10))
assert_equal(18, part1(SAMPLE, limit: 11))
assert_equal(3068, part1(SAMPLE))
# assert_equal(3193, part1(DATA))
# puts "pre-period = #{part1(SAMPLE, limit: 15)}"
# puts "at 15 + 35 = #{part1(SAMPLE, limit: 50)}"
# puts "with extra = #{part1(SAMPLE, limit: 15 + 35 + 12)}"
# puts "Part 1: #{part1(DATA)}"


# assert_equal(1514285714288, part1(SAMPLE, limit: 1_000_000_000_000, raise_on_loop: true))
# puts "pre-period = #{part1(DATA, limit: 197)}"
# puts "at 197 + 1739 = #{part1(DATA, limit: 197 + 1739)}"
# puts "with extra = #{part1(DATA, limit: 197 + 1739 + 211)}"


# assert_equal(0, part2(SAMPLE))
# puts "Part 2 10_000: #{part1(DATA, limit: 10_000)}"
# puts "Part 2 100_000: #{part1(DATA, limit: 100_000)}"
# puts "Part 2 100_000_000: #{part1(DATA, limit: 100_000_000)}"
puts "Part 2: #{part1(DATA, limit: 1000000000000)}"
# 1_577_343_300_745