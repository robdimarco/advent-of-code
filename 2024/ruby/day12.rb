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
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

require 'set'
def part1(data)
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
  groups.reject(&:empty?).map{|g| perimeter(g) * g.size}.sum
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

puts part1(TEST_DATA)
puts part1(TEST_DATA_2)
puts part1(REAL_DATA)
