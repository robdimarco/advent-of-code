sample=<<~TXT.lines.map(&:strip)
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
TXT

real = File.open("day12.txt").read.lines.map(&:strip)

def strip(pattern)
  2.times do
    loop do 
      break if pattern.empty? || pattern[0] != '.'
      pattern = pattern[1..-1]
    end
    pattern.reverse
  end
  pattern
end

def combos_for_line(args, cache = {})
  # puts "Checking #{args}"
  pattern, arrangement = args
  return cache[args] if cache[args]

  tokens = pattern.split(/\.+/).reject(&:empty?)
  if tokens.empty?
    # puts "no tokens"
    return cache[args] = 0 
  end

  if tokens.map(&:size) == arrangement
    # puts "full match"
    return cache[args] = 1 
  end

  t = tokens.first
  if t.chars.uniq == ['#']
    # puts "found token #{t}"
    if t.size != arrangement[0]
      # puts "size != arrangement for all #"
      return cache[args] = 0 
    end
    pattern = tokens[1..-1].join('.')
    arrangement = arrangement[1..-1]
    if pattern.empty? && arrangement.size > 1
      # puts "pattern empty"
      return cache[args] = 0 
    end
    if arrangement.size == 0
      if pattern.index('#').nil?
        # puts "Can all be ."
        return cache[args] = 1
      else
        # puts "no arrangement, have #"
        return cache[args] = 0
      end
    end
    # puts "changed arrangement to #{pattern} / #{arrangement}"
  end

  idx = pattern.index('?')
  if idx.nil?
    # puts "No more subs"
    return cache[args] = 0 
  end

  cache[args] = combos_for_line([pattern.sub('?', '.'), arrangement], cache) + combos_for_line([pattern.sub('?', '#'), arrangement], cache)
end

def parse(lines)
  lines.map do |line|
    a, b = line.split(' ')
    [a, b.split(',').map(&:to_i)]
  end
end

def part1(lines)
  data = parse(lines)
  # data = [data[-1]]
  data.map do |d|
    combos_for_line(d)
  end.sum
end

def part2(lines)
  data = parse(lines)
  data.map do |(a, b)|
    a = ([a] * 5).join("?")
    i = combos_for_line([a, b *5])
    puts "  #{i}"
    i
  end.sum
end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real)

