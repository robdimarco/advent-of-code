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

def build_map(data)
  base = {
    nodes: [],
    lines: Hash.new(){|h,k| h[k] = []},
  }
  (0...data.size).each do |r|
    (0...data[r].size).each do |c|
      if data[r][c] == "^"
        base[:start] = [r, c]
      elsif data[r][c] == "#"
        base[:nodes].push([r, c])
      end
    end
  end

  base[:nodes].each do |(r,c)|
    [[0,1], [0,-1], [1,0],[1, -1]].each do |(dr, dc)|
      paths = []
      rr = r
      cc = c
      loop do
        rr = rr + dr
        cc = cc + dc
        break if rr < 0 || cc < 0 || rr >= data.size || cc >= data[rr].size || data[rr][cc] == "#"
        paths.push([rr, cc])
      end
      base[:lines][[r,c, dr, dc]].push([rr, cc]) if paths.any?
    end
  end
  base
end

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

  return [[nr, nc], dir, path.push({pos: [nr, nc], dir: dir})]
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
  path = [{pos: pos, dir: dir}]
  loop do 
    v = move(data, pos, dir, path)
    return path unless v
    pos, dir, path = v
  end
  path
end

def find_loop(data)
  pos = find_start(data)
  dir = [-1, 0]
  path = [{pos: pos, dir: dir}]
  loop do 
    v = move(data, pos, dir, path)
    return false if v.nil?
    return true if path.uniq.size != path.size
    pos, dir, path = v
  end
end

def part1(data)
  find_path(data).map {|h| h[:pos]}.uniq.count
end

def part2(data)
  cnt = 0
  start = find_start(data)
  points = find_path(data).map {|h| h[:pos]}.uniq - [start]
  puts "Possible #{points.size}"
  points.each do |(r, c)|
    data[r][c] = "#"
    if find_loop(data)
      cnt +=1 
      print 'x'
    else
      print '.'
    end
    data[r][c] = "."
  end
  cnt
end

# puts part1(TEST_DATA)
# puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)
