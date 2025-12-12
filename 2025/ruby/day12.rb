
TEST_DATA =<<~DATA
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
DATA
REAL_DATA = File.read('day12.txt')
Region = Struct.new(:length, :width, :quantities) do
  def area
    length * width
  end
end
def parse(data)
  shapes = []
  regions = []

  lines = data.lines
  until lines.empty? do
    line = lines.shift
    if line =~ /^\d+:/
      s = []
      loop do
        l = lines.shift
        break if l.strip.empty?
        s.push(l.strip)
      end
      shapes.push(s)
    else
      size, qs = line.split(": ")
      l, w = size.split('x')
      regions.push(Region.new(l.to_i, w.to_i, qs.split(' ').map(&:to_i)))
    end
  end
  [shapes, regions]
end

def part1(data)
  shapes, regions = parse(data)
  sizes = shapes.map {|s| s.join.chars.count {|n|n=="#"}}
  regions.count do |region|
    used = 0
    region.quantities.each_with_index do |q, idx|
      used += q * sizes[idx]
    end
    region.area >= used
    # puts "#{region.area} >= #{used}"
  end
  # puts parse(data).inspect
end

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
