
TEST_DATA =<<~DATA
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   + 
DATA
REAL_DATA = File.read('day6.txt')
def parse(data)
  lines = data.lines.map(&:strip)
  grid = lines[0..-2].map do |line|
    line.split.map(&:to_i)
  end
  vals = []
  grid.each_with_index do |row|
    row.each_with_index do |val, idx|
      vals[idx] ||= []
      vals[idx] << val
    end
  end
  operations = lines[-1].split.map(&:to_sym)
  [vals, operations]
end

def part1(data)
  vals, ops = parse(data)
  sum = 0
  vals.each_with_index do |col, idx|
    sum += col.reduce(ops[idx])
  end
  sum
end

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
