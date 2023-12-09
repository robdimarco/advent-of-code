sample=<<~TXT.lines.map(&:strip)
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
TXT

real = File.open("day9.txt").read.lines.map(&:strip)

def parse(lines)
  lines.map {|l| l.scan(/[\-\d]+/).map(&:to_i)}
end

def derive(line)
  i = 1
  rv = []
  loop do 
    break if i == line.size
    rv.push(line[i] - line[i-1])
    i += 1
  end
  rv
end

def pyramid(stack)
  return stack if stack.last.uniq == [0]
  # puts stack.last.inspect
  stack + pyramid([derive(stack.last)])
end

def part1(lines)
  v = parse(lines).map do |l|
    pyr = pyramid([l])
    i = pyr.size - 2
    loop do 
      break if i == -1
      pyr[i].push(pyr[i].last + pyr[i+1].last)
      i -= 1
    end
    pyr
  end
  v.map(&:first).map(&:last).sum
end

def part2(lines)
end

puts part1(sample)
puts part1(real)

# puts part2(sample)
# puts part2(real)
