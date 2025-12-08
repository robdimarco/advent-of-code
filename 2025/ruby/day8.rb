
require 'pp'
TEST_DATA =<<~DATA
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
DATA
REAL_DATA = File.read('day8.txt')
Point = Struct.new(:x, :y, :z) do
  def distance(other)
    ((x - other.x) ** 2 + (y - other.y) ** 2 + (z - other.z) ** 2)**0.5
  end
end

def parse(data)
  data.lines.map do |line|
    Point.new(*line.split(',').map(&:to_i))
  end
end

def part1(data, n=10)
  points = parse(data)
  circuits = Hash.new {|h, k| h[k] = [k] }
  distances = []
  points.each_with_index do |p, idx|
    points[idx+1..-1].each do |o|
      distances.push([p, o, p.distance(o)])
    end
  end
  distances.sort_by!{|a| a[2]}

  distances[0...n].each do |p, o, d|
    circuit = (circuits[p] + circuits[o]).uniq.sort_by{|pt| [pt.x, pt.y, pt.z]}
    circuit.each do |point|
      circuits[point] = circuit
    end
  end
  # pp circuits

  circuits.values.uniq.map(&:size).sort.last(3).inject(&:*)
end

def part2(data)
  points = parse(data)
  circuits = Hash.new {|h, k| h[k] = [k] }
  distances = []
  points.each_with_index do |p, idx|
    points[idx+1..-1].each do |o|
      distances.push([p, o, p.distance(o)])
    end
  end
  distances.sort_by!{|a| a[2]}

  distances.each do |p, o, d|
    circuit = (circuits[p] + circuits[o]).uniq.sort_by{|pt| [pt.x, pt.y, pt.z]}
    circuit.each do |point|
      circuits[point] = circuit
    end
    return [p.x, o.x, p.x * o.x].join(",") if circuit.size == points.size
  end
  # pp circuits

  circuits.values.uniq.map(&:size).sort.last(3).inject(&:*)
end

# puts "Part 1"
# puts part1(TEST_DATA, 10)
# puts part1(REAL_DATA, 1000) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
