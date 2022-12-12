def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'algorithms'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
TEXT

def run(data)
  grid = data.lines.map {|l| l.strip.chars}
  start_pos = nil
  grid.each_with_index do |row, y|
    row.each_with_index do |val, x|
      start_pos = [y, x] if val == 'S'
    end
  end

  to_check = Containers::PriorityQueue.new
  to_check.push([start_pos, []], 0)
  visited = {}
  while !to_check.empty?
    pos, path = to_check.pop
    # puts "Checking #{pos.inspect} with path #{path.size}"
    y, x = pos
    next if y < 0 || x < 0 || y >= grid.size || x >= grid[y].size
    next if visited[[x,y]] && visited[[x,y]] <= path.size
    # next if path.size > 7
    next if path.include?(pos)
    # puts "Checking #{pos.inspect} with path #{path}"

    letter = grid[y][x]
    visited[[x,y]] = path.size
    if letter == 'E'
      shortest_path = path.size if shortest_path.nil? || shortest_path > path.size
      next
    end
    letter = 'a' if letter == 'S'
    
    [[1,0], [-1, 0], [0, 1], [0, -1]].each do |(dx, dy)|
      new_y = dy + y
      new_x = dx + x
      next if new_y < 0 || new_x < 0 || new_y >= grid.size || new_x >= grid[y].size

      new_pos = [new_y, new_x]
      next if path.include?(new_pos)

      new_path = path + [pos]

      next_letter = grid[new_y][new_x]
      next_letter = 'z' if next_letter == 'E'
      if next_letter.ord < letter.ord + 2
        # puts "Queuing #{new_pos} #{next_letter} #{letter.ord} (#{letter} -> #{next_letter})"
        to_check.push([new_pos, new_path], -new_path.size) 
      end
    end
  end
  shortest_path
end

assert_equal(31, run(SAMPLE))
puts "Part 1 #{run(DATA)}"

# assert_equal(0, run(SAMPLE))
# puts "Part 1 #{run(DATA)}"
