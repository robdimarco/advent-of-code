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
puts  data.lines.map {|l| parse_line(l.strip)}.select {|n| real?(n)}.map {|n| n[:sector]}.sum