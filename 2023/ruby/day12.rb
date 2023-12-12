sample=<<~TXT.lines.map(&:strip)
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
TXT

real = File.open("day12.txt").read.lines.map(&:strip)

def count_for_line(line)
  line.chars.count {|c| c == '?'} 
end

def combos_for_line(line)
  a = %w(# .)
  cnt = count_for_line(line)
  rv = []
  (2**cnt).times do |i|
    idxs = i.to_s(2).rjust(cnt, '0').chars.map(&:to_i)
    l = line
    idxs.each do |idx|
      l = l.sub('?', a[idx])
    end
    rv << l
  end
  rv
end

def parse(lines)
  lines.map do |line|
    a, b = line.split(' ')
    {pattern: a, arrangements: b.split(',').map(&:to_i)}
  end
end

def part1(lines)
  data = parse(lines)
  data.map do |d|
    c = combos_for_line(d[:pattern])
    c.select {|cc| cc.scan(/\#+/).map(&:size) == d[:arrangements]}.size
  end.sum
end

def part2(lines)
end

puts part1(sample)
puts part1(real)

# puts part2(sample)
# puts part2(real)

