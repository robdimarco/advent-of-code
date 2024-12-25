TEST_DATA = <<~DATA
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

def parse(data)
  blocks = data.split("\n\n")
  rv = {
    locks: [],
    keys: []
  }
  blocks.each do |block|
    lines = block.lines.map(&:strip)
    vals = [0] * 5
    (1..5).each do |row|
      (0...5).each do |col|
        if lines[row][col] == "#"
          vals[col] += 1 
        end
      end
    end
    if block[0][0] == "#"
      rv[:locks] << vals
    else
      rv[:keys] << vals
    end
  end
  [rv[:locks], rv[:keys]]
end

def part1(data)
  locks, keys = parse(data)
  cnt = 0
  locks.each do |lock|
    keys.each do |key|
      v = (0...lock.length).map {|n| lock[n] + key[n]}.uniq
      cnt += 1 unless v.any? {|n| n > 5}
    end
  end
  cnt
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)