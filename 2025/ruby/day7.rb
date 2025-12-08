
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
        grid[r_idx + 1][c_idx] = 1
      elsif cell == "^"
        prev = grid[r_idx - 1][c_idx].to_i
        if prev > 0
          if c_idx > 0
            if grid[r_idx][c_idx - 1].to_i > 0
              grid[r_idx][c_idx - 1] += prev
            else
              grid[r_idx][c_idx - 1] = prev 
            end
          end
          if c_idx < row.length - 1
            if grid[r_idx][c_idx + 1].to_i > 0
              grid[r_idx][c_idx + 1] += prev
            else
              grid[r_idx][c_idx + 1] = prev 
            end
          end
          cnt += 1
        end
      elsif r_idx > 0 && prev > 0
        grid[r_idx][c_idx] = grid[r_idx][c_idx].to_i + prev
      end
    end
  end
  # puts grid.map(&:join).join("\n")
  [cnt, grid[-1].map(&:to_i).sum].join(",")
end


puts "Part 1,2"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

