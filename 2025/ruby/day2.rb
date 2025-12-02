
TEST_DATA =<<~DATA.strip
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
DATA
REAL_DATA = File.read('day2.txt').strip


def part1(data)
  cnt = 0
  data.split(',').each do |range|
    range_start, range_end = range.split('-').map(&:to_i)
    # puts "Processing range #{range_start}-#{range_end}"
    (range_start..range_end).each do |num|
      v = num.to_s
      v1 = v[0...v.length / 2]
      v2 = v[(v.length / 2)...(v.length)]
      # puts "Comparing #{v1} and #{v2}"
      if v1 == v2
        # puts num
        cnt += num
      end
    end
  end
  cnt
end

def part2(data)
  cnt = 0
  data.split(',').each do |range|
    range_start, range_end = range.split('-').map(&:to_i)
    (range_start..range_end).each do |num|
      v = num.to_s
      vals = []
      (1..v.length / 2).each do |size|
        s = v[0, size]
        re = Regexp.new("^(#{s})+$")
        if v =~ re && !vals.include?(num)
          vals.push(num)
          cnt += num
        end
      end
    end
  end
  cnt
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
