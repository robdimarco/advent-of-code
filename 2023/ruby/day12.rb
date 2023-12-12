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

def counts(pattern)
  rv = [0]
  pattern.each do |c|
    if c =='#'
      rv[-1] += 1 
    else
      rv.push(0) if rv[-1] > 0
    end
  end
  rv = rv[0..-2] if rv[-1] == 0
  rv
end

def valid?(pattern, arrangement)
  cnt = 0
  arrangement = arrangement.dup
  a = arrangement.shift.to_i
  pattern.each do |c|
    case c
    when '#'
      cnt += 1
      return false if cnt > a
    when '.'
      if cnt > 0
        return false if cnt < a
        a = arrangement.shift.to_i
        cnt = 0
      end
    when '?'
      return true
    end
  end
  cnt == a
end
# puts valid?('????'.chars, [3])
# puts valid?('.???'.chars, [3])
# puts valid?('.#.?????'.chars, [3])
# puts valid?('.#'.chars, [3])
# puts valid?('.###'.chars, [3])
# puts valid?('.###.'.chars, [3])
# puts valid?('.##?.'.chars, [3])
# puts valid?('.##.?.'.chars, [3])
# puts valid?('##.?.'.chars, [3])
# puts valid?('###.?.'.chars, [3])

def combos_for_line(args)
  cnt = 0
  to_check = [args]
  while to_check.any?
    pattern, arrangement = to_check.shift
    pattern=strip(pattern)

    # If no more substitutions can be made, we can look at the count match
    next_sub = pattern.index('?')
    if next_sub.nil?
      cnt += 1 if counts(pattern) == arrangement
      next
    end

    ['#', '.'].each do |c|
      npattern = pattern.dup
      npattern[next_sub] = c
      to_check.push([npattern, arrangement]) if valid?(npattern, arrangement)
    end
  end
  cnt
end

def parse(lines)
  lines.map do |line|
    a, b = line.split(' ')
    [a.chars, b.split(',').map(&:to_i)]
  end
end

def part1(lines)
  data = parse(lines)
  data.map do |d|
    combos_for_line(d)
  end.sum
end

def part2(lines)
  data = parse(lines)
  data.map do |(a, b)|
    a = ([a] * 5).map(&:join).join("?").chars
    combos_for_line([a, b *5])
  end.sum
end

puts part1(sample)
# puts part1(real)

puts part2(sample)
# puts part2(real)

