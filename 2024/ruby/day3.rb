TEST_DATA =<<~DATA.lines.map(&:strip).join
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
DATA
REAL_DATA = File.read('day3.txt').lines.map(&:strip).join
TEST_DATA2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

def part1(data)
  parts = data.scan(/mul\(\d{1,3},\d{1,3}\)/)
  parts.reduce(0) do |acc, pair| 
    acc += pair.scan(/\d+/).map(&:to_i).reduce(1) {|a, n| a*n}
  end
end

def part2(data)
  parts = data.scan(/(?:mul\(\d{1,3},\d{1,3}\))|(?:do\(\))|(?:don't\(\))/)
  enabled = true
  parts.reduce(0) do |acc, pair|
    if pair == "do()" || pair == "don't()"
      enabled = pair == "do()"
    else
      acc += pair.scan(/\d+/).map(&:to_i).reduce(1) {|a, n| a*n} if enabled
    end
    acc
  end
end

puts part2(TEST_DATA)
puts part2(REAL_DATA)
puts part2(TEST_DATA2)
puts part2(REAL_DATA)