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

def part1(input, get = [1_000,2_000,3_000])
  start = []
  input.lines.each_with_index {|n, idx| start.push([n.to_i, idx])}
  current = start.dup
  start.each do |entry|
    # binding.break
    n, _ = entry
    idx = current.index(entry)
    current.delete(entry)
    current.rotate!(n)
    current.insert(idx, entry)
    # puts current.map(&:first).inspect
  end
  # binding.break
  vals = current.map(&:first)
  zero = vals.index(0)
  # binding.break
  Array(get).sum do |idx|
    vals[(zero + idx) % vals.size]
  end
end

def part2(input)
end

assert_equal(3, part1(SAMPLE))

puts "Part 1: #{part1(DATA)}"