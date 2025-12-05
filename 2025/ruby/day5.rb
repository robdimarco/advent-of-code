
TEST_DATA =<<~DATA
3-5
10-14
16-20
12-18

1
5
8
11
17
32
DATA
REAL_DATA = File.read('day5.txt')

def parse(data)
  sections, numbers = data.split("\n\n")
  ranges = sections.lines.map do |line|
    start_str, end_str = line.strip.split('-')
    (start_str.to_i..end_str.to_i)
  end
  nums = numbers.lines.map(&:to_i)
  [ranges, nums]
end

def part1(data)
  ranges, nums = parse(data)
  count = 0
  nums.each do |num|
    if ranges.any? {|r| r.include?(num)}
      count += 1
      next
    end
  end
  count
end

def part2(data)
  ranges, _ = parse(data)
  loop do 
    merged = false
    ranges.each_with_index do |r1, idx1|
      ranges.each_with_index do |r2, idx2|
        next if idx1 == idx2
        if overlap?(r1, r2)
          new_range = [r1.begin, r2.begin].min..[r1.end, r2.end].max
          ranges[idx1] = new_range
          ranges.delete_at(idx2)
          merged = true
          break
        end
      end
      break if merged
    end

    break unless merged
  end
  ranges.map(&:size).sum
end

def overlap?(r1, r2)
  r1.include?(r2.begin) || r1.include?(r2.end)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
