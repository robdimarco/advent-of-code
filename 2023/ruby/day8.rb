sample=<<~TXT.lines.map(&:strip)
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
TXT

sample2 =<<~TXT.lines.map(&:strip)
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
TXT

sample3 =<<~TXT.lines.map(&:strip)
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
TXT

real = File.open("day8.txt").read.lines.map(&:strip)

def parse(lines)
  directions = lines.shift.chars
  lines.shift
  elements = lines.each_with_object({}) do |l, h|
    start, opts = l.split(' = ')
    a,b = opts.scan(/[A-Z\d]+/)
    h[start] = {L: a, R: b}
  end

  [directions, elements]
end

def journey(directions, elements)
  i = 0
  pos = 'AAA'
  loop do
    dir = directions[i % directions.size]
    cur = elements[pos]
    pos = cur[dir.to_sym]
    i += 1
    break if pos == 'ZZZ'
  end
  i
end

def journey2(directions, elements)
  all_pos = elements.keys.select {|s| s[-1] == 'A'}
  dists = all_pos.map do |pos|
    i = 0
    loop do
      dir = directions[i % directions.size]
      cur = elements[pos]
      pos = cur[dir.to_sym]
      i += 1
      break if pos[-1] == 'Z'
    end
    i
  end
  reduce(dists)
end

def reduce(nums)
  rv = Hash.new(0)
  nums.each do |n|
    f = factors(n)
    f.each do |ff, c|
      rv[ff] = c if rv[ff] < c
      # puts rv.inspect
    end
  end
  rv.map {|k,v| k**v}.reduce(:*)
end

def factors(num)
  factors = []
  i = 2
  loop do
    if num % i == 0
      num = num / i
      factors.push(i)
    else
      i += 1
    end

    break if num == 1
  end
  factors.each_with_object(Hash.new(0)) {|n, h| h[n] += 1}
end

def part1(lines)
  a, b = parse(lines)
  journey(a, b)
end

def part2(lines)
  a, b = parse(lines)
  journey2(a, b)
end

# puts part1(sample)
# puts part1(sample2)
# puts part1(real)

puts part2(sample3)
puts part2(real)
# puts factors(300)
# puts reduce([10, 300, 7, 14])
