sample=<<~TXT.lines.map(&:strip)
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
TXT

real = File.open("day13.txt").read.lines.map(&:strip)

def match(pattern, skip_score)
  i = 0
  loop do
    break if i >= pattern.size - 1
    above = pattern[0..i].reverse
    below = pattern[(i+1)..(2*i + 1)]
    above = above[0...below.size] 
    return i if above == below && skip_score != i
    i += 1
  end
  -1
end

def parse(lines)
  rv = [[]]
  lines.each do |x|
    if x.empty?
      rv.push([])
    else
      rv[-1].push(x .chars)
    end
  end
  rv
end
def transform(pattern)
  s = pattern[0].size
  rv = []
  s.times do
    rv.push([])
  end

  i = 0
  loop do
    break if i >= s
    pattern.each do |p|
      rv[i].push(p[i])
    end
    i += 1
  end
  rv
end

def evaluate(p, skip_score = -2)
  i = match(p, (skip_score/100 - 1))
  if i > -1 && (i + 1) * 100 != skip_score
    (i + 1) * 100
  else
    t = transform(p)
    v = match(t, skip_score - 1) + 1
    v == skip_score ? -2 : v
  end
end

def with_increments(p)
  orig = evaluate(p)
  size = p.size * p[0].size
  k = 0
  loop do 
    break if k >= size
    np = p.map {|pp| pp.dup}
    r = k / p[0].size
    c = k % p[0].size
    np[r][c] = np[r][c] == "#" ? '.' : '#'

    v = evaluate(np, orig)
    if v > 0
      return v 
    end
    k += 1
  end
  -1
end

def part1(lines)
  parse(lines).map {|p| evaluate(p)}.sum
end

def part2(lines)  
  parse(lines).map {|p| with_increments(p)}.sum
end

puts part1(sample)
puts part1(real)

puts part2(sample).inspect
puts part2(real).inspect

