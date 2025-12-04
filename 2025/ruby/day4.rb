
TEST_DATA =<<~DATA
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
DATA
REAL_DATA = File.read('day4.txt')

def parse(data)
  result = {}
  data.lines.each_with_index do |row, y|
    row.strip.chars.each_with_index do |char, x|
      result[Complex(x,y)] = char
    end
  end
  result
end

def part1(data)
  r = parse(data)
  count = 0
  r.each do |k,v|
    next if v != '@'
    adjacent = [Complex(1,0), Complex(-1,0), Complex(1,1), Complex(1,-1),Complex(-1,1), Complex(-1,-1), Complex(0,1), Complex(0,-1)].map { |d| r[k + d] }
    count += 1 if adjacent.count { |c| c == '@' } < 4
  end
  count
end

def part2(data)
  r = parse(data)
  count = 0
  loop do
    cnt = 0
    r.each do |k,v|
      next if v != '@'
      adjacent = [Complex(1,0), Complex(-1,0), Complex(1,1), Complex(1,-1),Complex(-1,1), Complex(-1,-1), Complex(0,1), Complex(0,-1)].map { |d| r[k + d] }
      if adjacent.count { |c| c == '@' } < 4
        cnt += 1
        r.delete(k)
      end
    end
    if cnt == 0
      break
    else
      count += cnt
    end
  end
  count
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
