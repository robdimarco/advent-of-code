sample=<<~TXT.lines.map(&:strip)
.....
.S-7.
.|.|.
.L-J.
.....
TXT
sample2=<<~TXT.lines.map(&:strip)
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
TXT

real = File.open("day10.txt").read.lines.map(&:strip)


def parse(lines)
  lines.map(&:chars)
end
def start(maze)
  maze.each_with_index do |row, r|
    idx = row.index("S")
    return [r, idx] unless idx.nil?
  end
end


def push_if_valid(to_check, maze, dir, row, col, dist)
  case dir
  when :up
    rown = row - 1
    if rown >= 0
      c = maze[rown][col]
      to_check.push([[rown, col], dist + 1]) if %w(| 7 F).include?(c)
    end
  when :down
    rown = row + 1
    if rown < maze.size
      c = maze[rown][col]
      to_check.push([[rown, col], dist + 1]) if %w(| L J).include?(c)
    end
  when :left
    coln = col - 1
    if coln >= 0
      c = maze[row][coln]
      to_check.push([[row, coln], dist + 1]) if %w(- L F).include?(c)
    end
  when :right
    coln = col + 1
    if coln < maze[row].size
      c = maze[row][coln]
      to_check.push([[row, coln], dist + 1]) if %w(- 7 J).include?(c)
    end
  end
end

def build_path(lines)
  maze = parse(lines)
  st = start(maze)
  to_check = [[st, 0]]
  cache = {st => 0}
  loop do
    break if to_check.empty?

    pos, dist = to_check.shift

    next if cache[pos] && cache[pos] < dist
    
    row, col = pos
    next if row < 0 || row >= maze.size || col < 0 || col >= maze[row].size


    c = maze[row][col]
    next if c == '.'

    cache[pos] = dist

    case c
    when 'S'
      push_if_valid(to_check, maze, :up, row, col, dist)
      push_if_valid(to_check, maze, :down, row, col, dist)
      push_if_valid(to_check, maze, :left, row, col, dist)
      push_if_valid(to_check, maze, :right, row, col, dist)
    when '-'
      push_if_valid(to_check, maze, :left, row, col, dist)
      push_if_valid(to_check, maze, :right, row, col, dist)
    when '|'
      push_if_valid(to_check, maze, :up, row, col, dist)
      push_if_valid(to_check, maze, :down, row, col, dist)
    when 'L'
      push_if_valid(to_check, maze, :up, row, col, dist)
      push_if_valid(to_check, maze, :right, row, col, dist)
    when 'J'
      push_if_valid(to_check, maze, :up, row, col, dist)
      push_if_valid(to_check, maze, :left, row, col, dist)
    when '7'
      push_if_valid(to_check, maze, :down, row, col, dist)
      push_if_valid(to_check, maze, :left, row, col, dist)
    when 'F'
      push_if_valid(to_check, maze, :down, row, col, dist)
      push_if_valid(to_check, maze, :right, row, col, dist)
    end
  end

  cache
end

def part1(lines)
  build_path(lines).values.max
end

sample_2a=<<~TXT.lines.map(&:strip)
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
TXT

sample_2b=<<~TXT.lines.map(&:strip)
..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
..........
TXT

sample_2c=<<~TXT.lines.map(&:strip)
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
TXT

sample_2d=<<~TXT.lines.map(&:strip)
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
TXT


def part2(lines)
  maze = parse(lines)
  path = build_path(lines)
  i = 0
  maze.size.times do |row|
    cnt = 0
    hit_loop = false
    maze[row].size.times do |col|
      c = maze[row][col]
      if path.include?([row, col])
        cnt += 1 if %w(| J L).include?(c)
        cnt += 1 if c == "S" && (path[[row - 1, col]] == 1)
        next
      end

      if cnt % 2 == 1
        # puts "match on #{row}, #{col}"
        i += 1 
      end
    end
  end
  i
end


puts part2(sample_2a)
puts part2(sample_2b)
puts part2(sample_2c)
puts part2(sample_2d)
puts part2(real)
