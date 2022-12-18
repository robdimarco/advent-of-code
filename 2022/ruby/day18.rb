def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

SAMPLE = <<~TEXT
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
TEXT

def parse(input)
  input.lines.each_with_object({}) do |l, h|
    h[l.strip.split(',').map(&:to_i)] = 6
  end
end

def part1(input)
  cubes = parse(input)
  cubes.keys.each do |c|
    x,y,z = c
    [[1,0,0], [0, 1, 0], [0, 0, 1], [1,0,0], [0, 1, 0], [0, 0, 1]].each do |(dx, dy, dz)|
      c2 = [x + dx, y + dy, z + dz]
      if cubes[c2]
        cubes[c] -= 1
      end
    end
  end
  cubes.values.sum
end
assert_equal(10, part1("1,1,1\n2,1,1"))
assert_equal(64, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"
# assert_equal(3193, part1(DATA))

# assert_equal(58, part2(SAMPLE))
