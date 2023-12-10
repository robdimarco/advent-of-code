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

def part1(lines)
  maze = parse(lines)
  st = start(maze)
  puts "Start #{st}"
  to_check = [[st, 0]]
  cache = {st => 0}
  loop do
    break if to_check.empty?

    pos, dist = to_check.shift
    # require 'debug' and binding.break  if pos == [2, 4]

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
  # puts "max #{cache.keys.select {|k| cache[k] == 2}}"
  # puts cache.inspect

  cache.values.max
end

def part2(lines)
end

puts part1(sample)
puts part1(sample2)
puts part1(real)

# puts part2(sample)
# puts part2(real)
