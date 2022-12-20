def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

SAMPLE = <<~TEXT
1
2
-3
3
-2
0
4
TEXT

def part1(input, get: [1_000,2_000,3_000], key: 1, mixes: 1)
  start = []
  input.lines.each_with_index {|n, idx| start.push([n.to_i * key, idx])}
  current = start.dup
  mixes.times do
    start.each do |entry|
      # binding.break
      n, _ = entry
      idx = current.index(entry)
      current.delete(entry)
      current.rotate!(n)
      current.insert(idx, entry)
      # puts current.map(&:first).inspect
    end
  end
  # binding.break
  vals = current.map(&:first)
  zero = vals.index(0)
  # binding.break
  Array(get).sum do |idx|
    vals[(zero + idx) % vals.size]
  end
end

def part2(input, get: [1_000,2_000,3_000], key: 811589153, mixes: 10)
  part1(input, get: get, key: key, mixes: mixes)
end

assert_equal(3, part1(SAMPLE))

puts "Part 1: #{part1(DATA)}"
assert_equal(1623178306, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"
