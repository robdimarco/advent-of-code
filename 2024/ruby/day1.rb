TEST_DATA =<<~DATA.lines
3   4
4   3
2   5
1   3
3   9
3   3
DATA
REAL_DATA = File.read('day1.txt').lines.map(&:strip)

def parse_lists(data)
  data.map {|n| n.split.map(&:to_i)}.each_with_object([[],[]]) {|n, (a,b)| a<<n[0]; b<<n[1]}.map(&:sort)
end

def part1(data)
  a, b = parse_lists(data)
  rv = 0
  until a.empty?
    aa = a.shift
    bb = b.shift
    rv += (aa-bb).abs
  end
  rv
end

def part2(data)
  a, b = parse_lists(data)  
  bb = b.each_with_object(Hash.new(0)) {|n, hsh| hsh[n] += 1}
  a.sum {|aa| aa * bb[aa]}
end

puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts part2(TEST_DATA)
puts part2(REAL_DATA) 