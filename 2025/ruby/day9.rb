
TEST_DATA =<<~DATA
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
DATA
REAL_DATA = File.read('day9.txt')

def area(p1, p2)
  ((p1[0]-p2[0]).abs + 1) * ((p1[1]-p2[1]).abs + 1)
end

def parse(data)
  data.lines.map {|line| line.split(',').map(&:to_i) }
end

def part1(data)
  points = parse(data)
  areas = []
  points.each_with_index do |p1, i|
    points[i+1..-1].each_with_index do |p2, j|
      areas << area(p1, p2)
    end
  end
  areas.max
end

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
