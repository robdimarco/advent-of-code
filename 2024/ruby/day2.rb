TEST_DATA =<<~DATA.lines
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
DATA
REAL_DATA = File.read('day2.txt').lines.map(&:strip)

def parse_data(data)
  data.map(&:split).map {|n| n.map(&:to_i)}
end

def part1(data)
  d = parse_data(data)
  cnt = 0
  d.each_with_index do |a, idx|
    vals = (0...(a.length - 1)).map do |k|
      a[k] - a[k+1]
    end
    pos = vals.reject{|n| n == 0 }.count {|n| n > 0}
    if vals.map(&:abs).max < 4 && [0, vals.length].include?(pos) && !vals.include?(0)
      cnt += 1
    end
  end
  cnt
end

def part2(data)
end

puts part1(TEST_DATA)
puts part1(REAL_DATA) 

# puts part2(TEST_DATA)
# puts part2(REAL_DATA) 