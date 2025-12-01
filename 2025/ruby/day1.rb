TEST_DATA =<<~DATA.lines.map(&:strip)
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
DATA
REAL_DATA = File.read('day1.txt').lines.map(&:strip)


def part1(data)
  pos = 50
  cnt = 0
  data.each do |line|
    dir, *amt = line.chars
    amt = amt.join.to_i
    amt *= -1 if dir == 'L'
    pos = (pos + amt) % 100
    cnt += 1 if pos == 0
  end
  cnt
end

def part2(data)
  pos = 50
  cnt = 0
  data.each do |line|
    dir, *amt = line.chars
    amt = amt.join.to_i
    cnt += amt / 100
    amt = amt % 100
    amt *= -1 if dir == 'L'

    pos_n = pos + amt
    if pos != 0 && (pos_n <= 0 || pos_n >= 100)
      cnt += 1 
    end
    pos = pos_n % 100
  end
  cnt
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
