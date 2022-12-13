def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'algorithms'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
TEXT

def right_order?(a, b)
  # puts "Checking #{a.inspect} vs. #{b.inspect}"
  i = -1
  loop do
    i += 1
    return true if a[i].nil?
    return false if b[i].nil?
      
    cmp_a = Array(a[i])
    cmp_b = Array(b[i])

    next if cmp_a == cmp_b
    if a[i].is_a?(Fixnum) && b[i].is_a?(Fixnum)
      return a[i] < b[i]
    else
      rv = right_order?(cmp_a, cmp_b)
      return rv unless rv.nil?
    end
  end
  nil
end

def parse(input)
  input.lines.reduce([]) do |acc, l|
    next acc if l.strip.empty?
    val = eval(l)
    if !acc[-1].nil? && acc[-1].size == 1
      acc[-1].push(val)
    else
      acc.push([val])
    end
    acc
  end
end

def part1(input)
  pairs = parse(input)
  rv = 0
  pairs.each_with_index do |(a, b), i|
    if right_order?(a, b)
      rv += i + 1 
      # puts "Match on #{a.inspect} <> #{b.inspect} at #{i+1}"
    end
  end
  rv    
end

assert_equal(0, part1(<<~TEXT))
[[[[7, 4], [4, 2, 5, 1, 6], [5, 3, 1, 1, 1], 3]], [3], [6, [0, 3, [2, 10], [5, 4, 5]]]]
[[[]], [], [], [], [8, [10, [2, 9, 2, 2, 0]], 2]]
TEXT

assert_equal(13, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

def part2(input)
  pairs = parse(input)
  pairs = pairs.reduce([]) do |acc, (a, b)|
    acc.push(a)
    acc.push(b)
    acc
  end
  pairs.push([[2]])
  pairs.push([[6]])
  pairs.sort! {|a,b| a == b ? 0 : (right_order?(a, b) ? -1 : 1)}
  # pp pairs
  (pairs.index([[2]]) + 1) * (pairs.index([[6]]) + 1)
end

assert_equal(140, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"