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

def match(pattern)
  i = 0
  loop do
    break if i >= pattern.size - 1
    above = pattern[0..i].reverse
    below = pattern[(i+1)..(2*i + 1)]
    above = above[0...below.size] 
    return i if above == below
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

def part1(lines)
  parse(lines).map do |p| 
    i = match(p)
    if i > -1
      (i + 1) * 100
    else
      t = transform(p)
      match(t) + 1
    end
  end.sum
end

def part2(lines)
end

puts part1(sample).inspect
puts part1(real)

# puts part2(sample)
# puts part2(real)

