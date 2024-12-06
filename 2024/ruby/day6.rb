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

def build_map(data)
  base = {
    collapsed: {
      rows: Hash.new{|h, k| h[k] = []},
      cols: Hash.new{|h, k| h[k] = []}
    }
  }
  (0...data.size).each do |r|
    (0...data[r].size).each do |c|
      if data[r][c] == "^"
        base[:start] = [r, c]
      elsif data[r][c] == "#"
        base[:collapsed][:rows][r].push(c)
        base[:collapsed][:cols][c].push(r)
      end
    end
  end
  # puts base.inspect
  # base[:collapsed][:rows].values.map(&:sort!)
  # base[:collapsed][:cols].values.map(&:sort!)
  base
end

def has_loop(m)
  rows = m[:collapsed][:rows]
  cols = m[:collapsed][:cols]
  r, c = m[:start]
  dr, dc = [-1, 0]
  path = [[r, c, dr, dc]]
  loop do 
    if dr == 1
      nn = cols[c].select {|rr| rr > r}.min
      break if nn.nil?
      r = nn - 1
      dr = 0
      dc = -1
    elsif dr == -1
      nn = cols[c].select {|rr| rr < r}.max
      break if nn.nil?
      r = nn + 1
      dr = 0
      dc = 1
    elsif dc == 1
      nn = rows[r].select {|cc| cc > c}.min
      break if nn.nil?
      c = nn - 1
      dr = 1
      dc = 0
    elsif dc == -1
      nn = rows[r].select {|cc| cc < c}.max
      break if nn.nil?
      c = nn + 1
      dr = -1
      dc = 0
    end
    return true if path.include?([r, c, dr, dc])
    path.push([r, c, dr, dc])
  end

  false
end

def part2(data)
  m = build_map(data)
  to_change = find_path(data).map {|h| h[:pos]}.uniq - [m[:start]]
  cnt = 0
  to_change.each do |(r, c)|
    m[:collapsed][:rows][r].push(c)
    m[:collapsed][:cols][c].push(r)
    if has_loop(m)
      cnt += 1 
    end
    m[:collapsed][:rows][r].reject!{|cc| cc == c}
    m[:collapsed][:cols][c].reject!{|rr| rr == r}
  end
  cnt
end
# puts part1(TEST_DATA)
# puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
