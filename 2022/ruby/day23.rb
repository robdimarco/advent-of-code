def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

SMALL_SAMPLE = <<~TEXT
.....
..##.
..#..
.....
..##.
.....
TEXT
SAMPLE = <<~TEXT
.......#......
.....###.#....
...#...#.#....
....#...##....
...#.###......
...##.#.##....
....#..#......
TEXT

def parse(input)
  rv = Set.new
  input.lines.each_with_index do |l, y|
    l.strip.chars.each_with_index do |c, x|
      rv.add([x,y]) if c == '#'
    end
  end
  # puts rv
  rv
end
WEST = [-1, 0]
NWEST = [-1, -1]
NORTH = [0, -1]
NEAST = [1, -1]
EAST  = [1, 0]
SEAST = [1, 1]
SOUTH = [0, 1]
SWEST = [-1, 1]
ALL_DIRS = [WEST , NWEST, NORTH, NEAST, EAST, SEAST, SOUTH, SWEST]
CHECK_ORDER = [
  [NORTH, NEAST, NWEST],
  [SOUTH, SEAST, SWEST],
  [WEST, SWEST, NWEST],
  [EAST, SEAST, NEAST]
]
def part1(input, turns: 10)
  elves = parse(input)
  turns.times do |n|
    moves = Hash.new do |h,k|
      h[k] = []
    end
    elves.each do |pos|
      x, y = pos
       
      move = pos
      if ALL_DIRS.any? {|(dx, dy)| elves.include?([x + dx, y + dy])}
        (0...CHECK_ORDER.size).each do |k|
          to_check = CHECK_ORDER[(n + k) % CHECK_ORDER.size]
          if to_check.none? {|(dx, dy)| elves.include?([x + dx, y + dy])}
            move = [x + to_check[0][0], y + to_check[0][1]]
            break
          end
        end
      end
      moves[move].push(pos)
    end

    new_elves = Set.new
    moves.each do |(move, poses)|
      if poses.size == 1
        # puts "Moving from #{poses[0].inspect} to #{move}"
        new_elves.add(move)
      else
        poses.each do |pos| 
          # puts "No movement from #{pos}"
          new_elves.add(pos)
        end
      end
    end
    # puts "****************"
    elves = new_elves
  end
  min_x = elves.map {|(x, _)| x}.min
  max_x = elves.map {|(x, _)| x}.max
  min_y = elves.map {|(_, y)| y}.min
  max_y = elves.map {|(_, y)| y}.max
  # binding.break
  (max_x - min_x + 1) * (max_y - min_y + 1) - elves.size
end


assert_equal(3, part1(SMALL_SAMPLE, turns: 0))
assert_equal(5, part1(SMALL_SAMPLE, turns: 1))
assert_equal(25, part1(SMALL_SAMPLE, turns: 10))
assert_equal(25, part1(SMALL_SAMPLE, turns: 12))
assert_equal(110, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

def part2(input)
end
assert_equal(nil, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"