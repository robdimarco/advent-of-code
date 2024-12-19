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
    # puts "Checking #{towel} against #{rem}"
    if towel == rem
      # print 'X'
      return true 
    end
    if rem.start_with?(towel)
      towels.each do |t| 
        to_check.push([t, rem[towel.size..-1]], [-1 * (rem.size - towel.size), t.size]) if rem.start_with?(towel + t)
      end
    end
  end
  # print '?'
  false
end

def part1(data)
  towels, patterns = parse(data)
  patterns.select { |pattern| match?(towels, pattern)}.size
end
# puts part1(TEST_DATA)
puts part1(REAL_DATA)
