TEST_DATA = <<~DATA
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
require 'algorithms'
require 'set'
def parse(data)
  lines = data.lines
  towels = lines.shift.strip.split(', ')
  lines.shift 
  patterns = lines.map(&:strip)
  [towels, patterns]
end

def match?(towels, pattern)
  to_check = Containers::PriorityQueue.new
  checked = Set.new
  towels.each {|towel| to_check.push([towel, pattern], [-pattern.size, towel.size]) if pattern.start_with?(towel)}
  until to_check.empty?
    towel, rem = to_check.pop
    next if checked.include?([towel, rem])
    checked.add([towel, rem])
    if towel == rem
      return true 
    end
    if rem.start_with?(towel)
      towels.each do |t| 
        to_check.push([t, rem[towel.size..-1]], [-1 * (rem.size - towel.size), t.size]) if rem.start_with?(towel + t)
      end
    end
  end
  false
end

def solutions(towels, pattern, cache)
  return cache[pattern] if cache[pattern]
  rv = 0
  towels.each do |t|
    if t == pattern
      rv += 1
    elsif pattern.start_with?(t)
      rv += solutions(towels, pattern[t.size..-1], cache)
    end
  end
  cache[pattern] = rv
end

def part1(data)
  towels, patterns = parse(data)
  patterns.select { |pattern| match?(towels, pattern)}.size
end

def part2(data)
  towels, patterns = parse(data)
  cache = {}
  patterns.map { |pattern| solutions(towels, pattern, cache)}.sum
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
