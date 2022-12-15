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
assert_equal(10, distance([[2, 0], [2,10]]))

def collapse(ranges)
  result = []
  cur = nil
  ranges.sort.each do |start, stop|
    if cur.nil?
      cur = [start, stop]
      next
    end

    cStart, cStop = cur
    if start <= cStop + 1
      cur = [cStart, [stop, cStop].max]
    else
      result.push(cur)
      cur = [start, stop]
    end
  end
  result.append(cur) unless cur.nil?
  result
end
assert_equal([[1,4]], collapse([[1,2],[2,4]]))
assert_equal([[1,4]], collapse([[1,2],[3,4]]))
assert_equal([[1,4]], collapse([[3,4], [1,2]]))
assert_equal([[1,4], [9, 11]], collapse([[3,4], [1,2], [9,11]]))

def vals_in_row(row, points)
  d = distance(points)
  sensor, beacon = points
  to_move = d - distance([sensor, [sensor[0], row]])
  return nil if to_move < 0
  min = sensor[0] - to_move
  max = sensor[0] + to_move
  min += 1 if [min, row] == beacon
  max -= 1 if [max, row] == beacon
  return nil if min > max
  # puts "#{points.inspect} => #{[min, max].sort.inspect}"
  [min, max].sort
end
assert_equal(nil, vals_in_row(-3, [[8, 7], [2, 10]]))
assert_equal([8,8], vals_in_row(-2, [[8, 7], [2,10]]))
assert_equal([3,14], vals_in_row(10, [[8, 7], [2,10]]))

def ranges_for_row(points, row)
  ranges = points.map do |p|
    vals_in_row(row, p)
  end.compact
  ranges = collapse(ranges)
end

def part1(input, row)
  points = parse(input)

  ranges_for_row(points, row).sum do |(x,y)|
    y - x + 1
  end
end

def truncate(range, min, max)
  [[range[0], min].max, [range[1], max].min]
end

assert_equal(0, part1(SAMPLE, -1_000_000))
assert_equal(26, part1(SAMPLE, 10))
puts "Part 1: #{part1(DATA, 2000000)}"

def part2(input, max)
  points = parse(input)
  sensors = points.map(&:first)
  beacons = points.map(&:last)

  (0...max).each do |row|
    print '.' if row % 100_000 == 0
    ranges = ranges_for_row(points, row)
    ranges = ranges.map {|r| truncate(r, 0, max)}
    ranges = collapse(ranges)

    if ranges.size == 2 && ranges[1][0] - ranges[0][1] == 2
      pos = [ranges[1][0] - 1, row]
      # require 'debug'; binding.break
      if !sensors.include?(pos) && !beacons.include?(pos)
        return (pos[0]) * 4000000  + pos[1]
      end
    end
  end
  nil
end

assert_equal(56000011, part2(SAMPLE, 20))
puts "Part 2: #{part2(DATA, 4000000)}"
