sample=<<~TXT.lines.map(&:strip).map(&:chars)
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
TXT
real = File.open("day21.txt").read.lines.map(&:strip).map(&:chars)

def valid?(r, c, data, extended = false)
  if extended
    data[r % data.size][c % data[0].size] != '#'
  else
    r > -1 && c > -1 && r < data.size && c < data[r].size && data[r][c] != '#'
  end
end

def start_pos(data)
  i = 0
  loop do
    r = i / data.size
    c = i % data.size
    if data[r][c] == 'S'
      return [r, c]
    end
    i += 1
  end
end

def dump(positions, data)
  min_r = [positions.map(&:first).min, 0].min
  max_r = [positions.map(&:first).max, data.size - 1].max
  min_c = [positions.map(&:last).min, 0].min
  max_c = [positions.map(&:last).max, data[0].size - 1].max
  print "For #{min_r} to #{max_r} -> #{min_c} to #{max_c}"
  puts
  (min_r..max_r).each do |r|
    (min_c..max_c).each do |c|
      if positions.include?([r,c])
        print "O"
      elsif data[r % data.size][c % data[r % data.size].size] == "#"
        print "#"
      else 
        print "."
      end
    end
    print "\n"
  end
  print "\n"
end

require 'set'
def run(data, steps, extended)
  positions = Set.new
  positions.add(start_pos(data))
  steps.times do |i|
    n = Set.new
    # puts "#{i}...#{positions.size}"
    positions.each do |(r, c)|
      [[0,1], [1, 0], [0, -1], [-1, 0]].each do |(dr, dc)|
        nr = r + dr
        nc = c + dc
        n.add([nr, nc]) if valid?(nr, nc, data, extended)
      end
    end
    positions = n
  end
  puts "Got #{positions.size} for #{steps}"
  positions.size
end

def part1(data)
  run(data, 64, false)
end

# https://mathworld.wolfram.com/LagrangeInterpolatingPolynomial.html
# 
# P(x) = ((x-x_2)(x-x_3))/((x_1-x_2)(x_1-x_3))y_1+((x-x_1)(x-x_3))/((x_2-x_1)(x_2-x_3))y_2+((x-x_1)(x-x_2))/((x_3-x_1)(x_3-x_2))y_3
# for x = [0, 1, 2], y = [y1, y2, y3]
# f(x) = (x-1)(x-2) * y1 /2  - (x)*(x-2) * y2 + x(x-1)*y3/2
#      = (x^2 - 3x + 2) * y1 /2 - (x^2 - 2x) * y2 + (x^2-x)* y3/2
#      = ax^2 + bx + c 
#        where a = (y1 / 2 - y2 + y3/2), b = -3 * y1 /2 + 2 (y2) - y3/2, c = y1
def simplifiedLagrange(y1, y2, y3)
  {
    a: y1 / 2 - y2 + y3 / 2,
    b: -3 * (y1 / 2) + 2 * y2 - y3 / 2,
    c: y1,
  }
end

def part2(data)
  # Grid is 131 lines long with S at 65,65.
  # Data repeats in a quadratic fashion for each full run through the grid
  #  e.g. point 65 == 0th point as we moved up and out of the grid, point 65+131 = point 2, etc.
  # So first 3 points we want to measure are N=65 (out of grid 1), N=65+131 (out of grid 2), N=65+2*131 (out of grid 3)

  # coef = simplifiedLagrange(run(data, 65, true), run(data, 65 + 131, true), run(data, 65 + 131 + 131, true))
  coef = simplifiedLagrange(3762, 33547, 93052)

  steps = 26_501_365
  target = (steps - 65) / 131 # Nice round number!, Gets us out and then repeats
  target * target * coef[:a] + target * coef[:b] + coef[:c]
end

# puts part1(sample)
# puts part1(real)

# puts part2(sample, 6, true)
# puts part2(sample, 10, true)
# puts part2(sample, 50, true)
# puts part2(sample, 100, true)
# puts part2(sample, 500)
# puts part2(sample, 1000)
# puts part2(sample, 5000)
puts part2(real)