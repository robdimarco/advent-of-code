TEST_DATA =<<~DATA.lines
3   4
4   3
2   5
1   3
3   9
3   3
DATA
REAL_DATA = File.read('day1.txt').lines.map(&:strip)

def part1(data)
  a, b = data.map {|n| n.split.map(&:to_i)}.each_with_object([[],[]]) {|n, (a,b)| a<<n[0]; b<<n[1]}.map(&:sort)
  rv = 0
  until a.empty?
    aa = a.shift
    bb = b.shift
    rv += (aa-bb).abs
  end
  rv
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)