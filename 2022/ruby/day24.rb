def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

S_SAMPLE = <<~TEXT
#.#####
#.....#
#>....#
#.....#
#...v.#
#.....#
#####.#
TEXT

SAMPLE = <<~TEXT
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
TEXT
def parse(input)
  input.lines.map do |l|
    l.strip.chars
  end
end

def distance(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def find_storms(map)
  rv = []
  map.each_with_index do |row, y|
    row.each_with_index do |c, x|
      rv.push([x,y,c]) if %w(> < ^ v).include?(c)
    end
  end
  rv
end
MOVES = {'>' => [1, 0], '<' => [-1, 0], '^' => [0, -1], 'v' => [0, 1], '.' => [0,0]}

def dump(pos, storms, map)
  s_by_pos = storms.group_by {|(x,y,c)| [x,y]}
  map.each_with_index do |row, y|
    row.each_with_index do |c, x|
      if pos == [x, y]
        print 'E'
      else
        if s_by_pos[[x,y]]
          if s_by_pos[[x,y]].size == 1
            print s_by_pos[[x,y]][0][2]
          else
            print s_by_pos[[x,y]].size
          end
        else
          print c == '#' ? '#' : '.'
        end
      end
    end
    puts
  end
end

def storms(map, time)
  @storms ||= {}
  return @storms[[map, time]] = find_storms(map) if time == 0
    
  @storms[[map, time]] ||= storms(map, time-1).map do |(x, y, c)|
    dx, dy = MOVES[c]
    new_pos = [x + dx, y + dy, c]
    if map[new_pos[1]].nil? || map[new_pos[1]][new_pos[0]].nil? || map[new_pos[1]][new_pos[0]] == '#'
      case MOVES[c]
      when [1, 0]
        new_pos[0] = 1
      when [-1, 0]
        new_pos[0] = map[0].size - 2
      when [0, 1]
        new_pos[1] = 1 # map[0][new_pos[0]] == '#' ? 1 : 0
      when [0, -1]
        new_pos[1] = map.size - 2 # map[-1][new_pos[0]] == '#' ? map.size - 2 : map.size - 1
      end
    end

    new_pos
  end
end

def move(pos, time, map)
  storms = storms(map, time)
  moves = MOVES.values.map do |(dx, dy)|
    n_x = pos[0] + dx
    n_y = pos[1] + dy

    if n_x >= 0 && n_y >= 0 && map[n_y] && map[n_y][n_x] && map[n_y][n_x] != '#' && storms.none? {|(x,y,_)| x == n_x && y == n_y}
      [n_x, n_y] 
    end
  end.compact
  moves
end

def part1(input)
  map = parse(input)
  st_pos = [map[0].index('.'), 0]
  e_pos = [map[-1].index('.'), map.size - 1]
  shortest_path(map, st_pos, e_pos, 0)
end

def shortest_path(map, st_pos, e_pos, start_time)
  to_check = Containers::PriorityQueue.new
  to_check.push([st_pos, start_time, []], -1 * distance(st_pos, e_pos))
  shortest_time = nil
  shortest_path = nil
  visited = Set.new
  visited.add([st_pos, start_time])

  until to_check.empty? do
    pos, time, path = to_check.pop
    if pos == e_pos
      if shortest_time.nil? || shortest_time > time
        shortest_time = time
        shortest_path = path
        next
      end
    end
    puts "Q: #{to_check.size} V: #{visited.size} St: #{shortest_time}" if rand(1000) == 0
    d_t = time + 1 

    moves = move(pos, d_t, map)
    # binding.break if pos == [1,2]
    moves.each do |m|
      if (shortest_time.nil? || shortest_time > d_t) && !visited.include?([m, d_t])
        visited.add([m, d_t])
        to_check.push([m, d_t, [m] + path], -1 * (d_t + distance(m, e_pos)))
      end
    end
  end
  # puts shortest_path.inspect
  shortest_time
end

assert_equal(10, part1(S_SAMPLE))
assert_equal(18, part1(SAMPLE))
# puts  "Part 1: #{part1(DATA)}"

def part2(input)
  map = parse(input)
  st_pos = [map[0].index('.'), 0]
  e_pos = [map[-1].index('.'), map.size - 1]
  t1 = shortest_path(map, st_pos, e_pos, 0)
  puts "t1 #{t1}"
  t2 = shortest_path(map, e_pos, st_pos, t1)
  puts "t2 #{t2}"
  t3 = shortest_path(map, st_pos, e_pos, t2)
end

assert_equal(54, part2(SAMPLE))
puts  "Part 2: #{part2(DATA)}"