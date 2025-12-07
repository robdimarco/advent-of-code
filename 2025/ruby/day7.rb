
TEST_DATA =<<~DATA
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
DATA
REAL_DATA = File.read('day7.txt')

def parse(data)
  data.lines.map(&:strip).map(&:chars)
end

def part1(data)
  grid = parse(data)
  cnt = 0
  grid.each_with_index do |row, r_idx|
    row.each_with_index do |cell, c_idx|
      if cell == "S"
        grid[r_idx + 1][c_idx] = "|"
      elsif cell == "^"
        if grid[r_idx - 1][c_idx] == "|"
          if c_idx > 0
            grid[r_idx][c_idx - 1] = "|"
          end
          if c_idx < row.length - 1
            grid[r_idx][c_idx + 1] = "|"
          end
          cnt += 1
        end
      elsif r_idx > 0 && grid[r_idx - 1][c_idx] == "|"
        grid[r_idx][c_idx] = "|"
      end
    end
  end
  # puts grid.map(&:join).join("\n")
  cnt
end

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
