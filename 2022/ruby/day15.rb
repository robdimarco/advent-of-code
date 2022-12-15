def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'algorithms'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
TEXT

def parse(data)
  data.lines.map do |l|
    l.scan(/x=[-\d]+, y=[-\d]+/).map {|m| m.scan(/[-\d]+/).map(&:to_i)}
  end
end

def distance(points)
  a, b = points

  distance = (a[0]-b[0]).abs + (a[1] - b[1]).abs
end
assert_equal(0, distance([[0,0], [0,0]]))
assert_equal(3, distance([[3,0], [0,0]]))
assert_equal(3, distance([[0,3], [0,0]]))
assert_equal(3, distance([[0, -3], [0,0]]))
assert_equal(3, distance([[-3 ,0], [0,0]]))
assert_equal(5, distance([[-3 ,2], [0,0]]))

def vals_in_row(row, points)
  d = distance(points)
  sensor, beacon = points
  to_move = d - distance([sensor, [sensor[0], row]])
  # require 'debug'; binding.break
  # puts sensor,inspect
  return [] unless to_move >= 0
  (-to_move..to_move).map do |dx|
    x = sensor[0] + dx
    x unless beacon == [x, row]
  end.compact
end
assert_equal([], vals_in_row(-3, [[8, 7], [2, 10]]))
assert_equal([8], vals_in_row(-2, [[8, 7], [2,10]]))
assert_equal((3..14).to_a, vals_in_row(10, [[8, 7], [2,10]]))

def part1(input, row)
  points = parse(input)
  points.flat_map do |p|
    vals_in_row(row, p)
  end.uniq.size
end

assert_equal(26, part1(SAMPLE, 10))
puts "Part 1: #{part1(DATA, 2000000)}"

def part2(input)
end

assert_equal(93, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"