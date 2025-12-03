
TEST_DATA =<<~DATA.lines.map{|l|l.strip.chars.map(&:to_i)}
987654321111111
811111111111119
234234234234278
818181911112111
DATA
REAL_DATA = File.read('day3.txt').lines.map{|l|l.strip.chars.map(&:to_i)}

def part1(data)
  cnt = 0
  data.each do |line|
    max = line[0..-2].max
    idx = line.index(max)
    max_2 = line[idx + 1..-1].max || 0
    # puts "adding #{max} * 10 + #{max_2}"
    cnt += max * 10 + max_2
  end
  cnt
end

def part2(data)
  cnt = 0
  data.each do |line|
    result = line.dup
    idx = 1
    while idx < result.size && result.size > 12
      if result[idx] > result[idx - 1]
        result.delete_at(idx - 1)
        if idx > 1
          idx -= 1
        end
      else
        idx += 1
      end
    end
    # puts result[0..11].join
    cnt += result[0..11].join.to_i
  #   puts line.join
  end
  cnt
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
