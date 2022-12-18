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

def cubes_with_sa(input)
  cubes = parse(input)
  cubes.keys.each do |c|
    x,y,z = c
    [[1,0,0], [0, 1, 0], [0, 0, 1], [-1,0,0], [0, -1, 0], [0, 0, -1]].each do |(dx, dy, dz)|
      c2 = [x + dx, y + dy, z + dz]
      if cubes[c2]
        cubes[c] -= 1
      end
    end
  end
  cubes
end

def part1(input)
  cubes_with_sa(input).values.sum
end
assert_equal(10, part1("1,1,1\n2,1,1"))
assert_equal(64, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

# def touches_air?(cube, cubes, min, max)
#   pq = Containers::PriorityQueue
#   pq.add(cube, -1 * distance_to_air(cube, min, max))
#   found_air = true
#   while !pq.empty? && !found_air
#     c = pq.pop
#     [[1,0,0], [0, 1, 0], [0, 0, 1], [-1,0,0], [0, -1, 0], [0, 0, -1]].each do |(dx, dy, dz)|
#     end
#   end
# end

def distance_to_center(cube, min, max)
  x, y, z = cube
  c = (min + max) / 2
  v = (x-c)**2 + (y-c)**2 + (z-c)**2
  v ** 0.5
end

def outside_steam(cubes, min, max)
  steam = Set.new
  (min..max).each do |x|
    (min..max).each do |y| 
      steam.add([x, y, min - 1])
      steam.add([x, y, max + 1])
      steam.add([x, min - 1, y])
      steam.add([x, max + 1, y])
      steam.add([min - 1, x, y])
      steam.add([max + 1, x, y])
    end
  end

  pq = Containers::PriorityQueue.new
  steam.each do |c|
    pq.push(c, -1 * distance_to_center(c, min, max))
  end

  until pq.empty? do
    sc = pq.pop
    x, y, z = sc
    [[1,0,0], [0, 1, 0], [0, 0, 1], [-1,0,0], [0, -1, 0], [0, 0, -1]].each do |(dx, dy, dz)|
      nc = [x+dx, y+dy, z+dz]
      if !steam.include?(nc) && !cubes.include?(nc) && nc.all? {|q| q >= min && q <= max}
        steam.add(nc)
        pq.push(nc, -1 * distance_to_center(nc, min, max))
      end
    end
  end
  steam
end

def part2(input)
  cubes = parse(input)
  min = cubes.keys.flatten.uniq.min
  max = cubes.keys.flatten.uniq.max

  steam = outside_steam(cubes, min, max)

  cubes.keys.each do |cube|
    x, y, z = cube
    [[1,0,0], [0, 1, 0], [0, 0, 1], [-1,0,0], [0, -1, 0], [0, 0, -1]].each do |(dx, dy, dz)|
      nc = [x+dx, y+dy, z+dz]
      if !steam.include?(nc)
        cubes[cube] -= 1
      end
    end
  end
  cubes.values.sum
end

assert_equal(58, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"
