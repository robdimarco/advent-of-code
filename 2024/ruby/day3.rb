TEST_DATA =<<~DATA.lines.map(&:strip).join
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
DATA
REAL_DATA = File.read('day3.txt').lines.map(&:strip).join

def part1(data)
  parts = data.scan(/mul\(\d{1,3},\d{1,3}\)/)
  parts.reduce(0) do |acc, pair| 
    acc += pair.scan(/\d+/).map(&:to_i).reduce(1) {|a, n| a*n}
  end
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)