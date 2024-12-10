TEST_DATA = <<~DATA
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

def parse(data)
  data.lines.map do |l|
    l.strip.chars.map(&:to_i)
  end
end
def starts(data)
  points = []
  (0...data.size).each do |r|
    (0...data[r].size).each do |c|
      points.push(Complex(r, c)) if data[r][c] == 0
    end
  end
  points
end

def walk(start, data)
  paths = []
  to_check = [[start]]
  while to_check.any?
    path = to_check.shift
    if path.size == 10
      paths.push(path)
      next
    end

    pos = path[-1]
    [1, -1, 1i, -1i].each do |d|
      npos = pos + d
      r = npos.real
      c = npos.imag
      if r >= 0 && c >= 0 && r < data.size && c < data[0].size
        if data[r][c] == path.size
          to_check.push(path + [npos])
        end
      end
    end
  end
  paths
end

def part1(data)
  data = parse(data)
  s = starts(data)
  s.map do |ss|
    walk(ss, data).map(&:last).uniq.size
  end.sum

end

def part2(data)
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)
