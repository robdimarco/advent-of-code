TEST_DATA = <<~DATA
AAAA
BBCD
BBCC
EEEC
DATA

TEST_DATA_2=<<~DATA
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
DATA
TEST_DATA_3=<<~DATA
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
DATA
TEST_DATA_4=<<~DATA
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

require 'set'
def groups(data)
  data = data.lines.map {|l| l.strip.chars}
  groups = []
  to_check = []
  (0...data.size).each do |r|
    (0...data[r].size).each do |c|
      g = []
      groups.push(g)
      to_check.push([Complex(r, c), g, data[r][c]])
    end
  end
  checked = Set.new
  while to_check.any?
    pos, group, v = to_check.shift
    next if checked.include?(pos)
    next if group.include?(pos)
    r = pos.real
    c = pos.imag
    next if r < 0 || c < 0 || r >= data.size || c >= data.size
    if v == data[r][c]
      group.push(pos)
      checked.add(pos)
      to_check.unshift([pos + 1, group, v])
      to_check.unshift([pos - 1, group, v])
      to_check.unshift([pos + 1i, group, v])
      to_check.unshift([pos - 1i, group, v])
    end
  end
  groups.reject(&:empty?)
end

def perimeter(group)
  cnt = group.size * 4
  group.each do |pos|
    [1, -1, 1i, -1i].each do |d|
      cnt -= 1 if group.include?(pos + d)
    end
  end
  cnt
end

def sides(group)
  edges = {
    1 => [],
    -1 => [],
    1i => [],
    -1i => [],
  }
  group.each do |pos|
    edges.keys.each do |d|
      edges[d].push(pos) unless group.include?(pos + d)
    end
  end
  cnt = 0
  edges.each do |d, points|
    next if points.empty?
    cnt += 1 
    points = points.sort_by {|p| d.real != 0 ? [p.real, p.imag] : [p.imag, p.real]}
    (1...points.size).each do |idx|
      if (points[idx-1] - points[idx]).abs > 1
        cnt += 1
      end
    end
  end
  cnt
end

def part1(data)
  groups(data).map{|g| perimeter(g) * g.size}.sum
end

def part2(data)
  groups(data).map{|g| sides(g) * g.size}.sum
end

# puts sides([0, 1, 1+1i, 1i]) == 4
# puts sides([0, 1i, 2i, 3i]) == 4
# puts sides([0]) == 4
# puts sides([0, 1, 1+1i, 2+1i]) == 8
# puts sides([0, 1i, 2i, 3i, 4i, 1, 2, 2+1i, 2+2i, 2+3i,2+4i,3,4,4+1i,4+2i,4+3i,4+4i]) == 12
 
# puts part1(TEST_DATA)
# puts part1(TEST_DATA_2)
puts part1(REAL_DATA)

# puts part2(TEST_DATA)
# puts part2(TEST_DATA_2)
# puts sides(groups(TEST_DATA_3)[0])
# puts part2(TEST_DATA_4)
# 
puts part2(REAL_DATA)
