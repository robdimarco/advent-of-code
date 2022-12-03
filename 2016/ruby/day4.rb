def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
def parse_line(line)
  m  = /^(?<name>.*)\-(?<sector>\d+)\[(?<cksum>[a-z]+)\]$/.match(line)
  raise "No match for #{line}" unless m
  {name: m['name'], sector: m['sector'].to_i, cksum: m['cksum']}
end

def real?(data)
  counts = data[:name].gsub(/[^a-z]/, '').chars.group_by {|c| c}
  keys = counts.keys.sort_by {|k|[counts[k].size, -k.ord]}.reverse
  # puts keys.inspect
  keys[0..4].join == data[:cksum]
end

[
  [true, 'aaaaa-bbb-z-y-x-123[abxyz]'], 
  [true, 'a-b-c-d-e-f-g-h-987[abcde]'], 
  [true,'not-a-real-room-404[oarel]'],
  [false,'totally-real-room-200[decoy]']
].each do |(exp, val)|
  assert_equal(exp, real?(parse_line(val)))
end

data = File.read('day4.txt')
real = data.lines.map {|l| parse_line(l.strip)}.select {|n| real?(n)}
print 'Part 1: '
puts real.map {|n| n[:sector]}.sum


def decrypt(data)
  data[:name].chars.map do |c|
    if c == '-'
      ' '
    else
      n = c.ord + (data[:sector] % 26)
      n = 'a'.ord + n - 'z'.ord - 1 if n > 'z'.ord
      n.chr
    end
  end.join
end
assert_equal('very encrypted name', decrypt({name: 'qzmt-zixmtkozy-ivhz', sector: 343}))
puts real.detect {|n| decrypt(n) == 'northpole object storage'}
