TEST_DATA =<<~DATA.lines.map(&:strip).map(&:chars)
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
DATA
REAL_DATA = File.read('day6.txt').lines.map(&:strip).map(&:chars)

def move(data, pos, dir, path)
  row, col = pos
  dr, dc = dir
  nr = row + dr
  nc = col + dc
  return if nr < 0 || nr >= data.length || nc < 0 || nc >= data[row].length

  v = data[nr][nc]
  if v == "#"
    dir = case dir
    when [-1, 0] then [0, 1]
    when [0, 1] then [1, 0]
    when [1, 0] then [0, -1]
    when [0, -1] then [-1, 0]
    else 
      raise "Doh #{dir}"
    end
    dr, dc = dir
    nr = row + dr
    nc = col + dc
  end

  return [[nr, nc], dir, path.push([nr, nc])]
end

def find_start(data)
  (0...data.size).each do |r|
    (0...data[r
  ].size).each do |c|
      return [r, c] if data[r][c] == "^"
    end
  end
  raise "No start found"
end

def find_path(data)
  pos = find_start(data)
  dir = [-1, 0]
  path = [pos]
  loop do 
    v = move(data, pos, dir, path)
    return path unless v
    pos, dir, path = v
  end
  path
end

def part1(data)
  find_path(data).uniq.count
end

def part2(data)
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)