
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
  points = parse(data)
  lines = []
  points.each_with_index do |p1, i|
    if i < points.length - 1
      p2 = points[i+1]
      lines << [p1, p2]
    else
      lines << [p1, points[0]]
    end
  end

  areas = []
  points.each_with_index do |p1, i|
    points[i+1..-1].each_with_index do |p2, j|
      intersect = lines.any? do |line|
        lx1, lx2 = [line[0][0], line[1][0]].sort
        ly1, ly2 = [line[0][1], line[1][1]].sort

        x1, x2 = [p1[0], p2[0]].sort
        y1, y2 = [p1[1], p2[1]].sort

        lx1 < x2 && lx2 > x1 && ly1 < y2 && ly2 > y1

      end
      areas << area(p1, p2) unless intersect
    end
  end
  areas.max
end

# puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
