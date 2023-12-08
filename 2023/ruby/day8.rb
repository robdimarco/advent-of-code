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

real = File.open("day8.txt").read.lines.map(&:strip)

def parse(lines)
  directions = lines.shift.chars
  lines.shift
  elements = lines.each_with_object({}) do |l, h|
    start, opts = l.split(' = ')
    a,b = opts.scan(/[A-Z]+/)
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

def part1(lines)
  a, b = parse(lines)
  journey(a, b)
end

def part2(lines)
end

puts part1(sample)
puts part1(sample2)
puts part1(real)

# puts part2(sample)
# puts part2(real)
