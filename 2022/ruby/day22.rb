def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

SAMPLE = <<~TEXT
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
TEXT
DIRS = [[1,0], [0,1], [-1,0], [0, -1]]

def parse(input)
  map_s, key = input.split("\n\n")
  map = {}
  s_pos = nil
  map_s.lines.each_with_index do |l, y|
    l.chars.each_with_index do |c, x|
      next if c =~ /\s/
      s_pos = [x,y] if c == '.' && !s_pos
      map[[x,y]] = c
    end
  end

  [map, key.scan(/(\d+|R|L)/).map(&:first), s_pos]
end

def part1(input)
  map, cmds, pos = parse(input)
  dir_idx = 0
  visited = {pos=>dir_idx}

  cmds.each do |cmd|
    if cmd == 'R'
      dir_idx = (dir_idx + 1) % DIRS.size
      visited[pos] = dir_idx
    elsif cmd == 'L'
      dir_idx = dir_idx == 0 ? (DIRS.size - 1) : (dir_idx - 1)
      visited[pos] = dir_idx
    else
      dx, dy = DIRS[dir_idx]
      steps = cmd.to_i
      steps.times do |s|
        n_pos = [pos[0] + dx, pos[1] + dy]
        v = map[n_pos]
        if v == '.'
          pos = n_pos
        elsif v == '#'
          next
        else 
          loop do
            n_pos = [n_pos[0] - dx, n_pos[1] - dy]
            if map[n_pos].nil?
              n_pos = [n_pos[0] + dx, n_pos[1] + dy]
              if map[n_pos] != '#'
                pos = n_pos
              else
                # puts "At wall at #{n_pos}"
              end
              break;
            end
          end
        end
        visited[pos] = dir_idx
      end
    end
  end
  dump(map, visited)
  (pos[1] + 1) * 1_000 + (pos[0] + 1) * 4 + dir_idx 
end

def dump(map, visited)
  max_x = map.keys.max {|(x,y)| x}.first
  max_y = map.keys.max {|(x,y)| y}.last
  puts
  max_y.times do |y|
    max_x.times do |x|
      c = map[[x,y]] || ' '
      if visited[[x,y]]
        c = case visited[[x,y]]
        when 0
          '>'
        when 1
          'v'
        when 2
          '<'
        when 3
          '^'
        end
      end
      print c
    end
    puts
  end
end

def part2(input)
  map, cmds, pos = parse(input)
  dir_idx = 0
  visited = {pos=>dir_idx}

  cmds.each do |cmd|
    if cmd == 'R'
      dir_idx = (dir_idx + 1) % DIRS.size
      visited[pos] = dir_idx
    elsif cmd == 'L'
      dir_idx = dir_idx == 0 ? (DIRS.size - 1) : (dir_idx - 1)
      visited[pos] = dir_idx
    else
      steps = cmd.to_i
      steps.times do |s|
        dx, dy = DIRS[dir_idx]
        n_pos = [pos[0] + dx, pos[1] + dy]

        v = map[n_pos]
        if v == '.'
          pos = n_pos
        elsif v == '#'
          next
        else 
          # binding.break
          n_pos, n_dir = calc(map, pos, dx, dy)

          if map[n_pos] != '#'
            pos = n_pos
            dir_idx = n_dir
          else
            # puts "At wall at #{n_pos}"
          end
        end
        visited[pos] = dir_idx
      end
    end
  end
  dump(map, visited)
  (pos[1] + 1) * 1_000 + (pos[0] + 1) * 4 + dir_idx 
end
# DIRS = [[1,0], [0,1], [-1,0], [0, -1]]
def calc(map, pos, dx, dy)
  sq_size = (map.keys.map(&:first).max + 1)/ 4

  n_dir = nil
  n_pos = nil
  case [pos[0] / sq_size, pos[1] / sq_size]
  when [2,0]
    # sq 1
    case [dx,dy]
    when [0, -1]
      # to sq 5 down
      n_pos = [pos[0], sq_size * 3 - 1]
      n_dir = 3
    when [-1, 0]
      # to sq 3 down
      n_pos = [pos[1] + sq_size, sq_size]
      n_dir = 2
    when [1, 0]
      # to sq 6 left
      n_pos = [sq_size * 4 - 1, sq_size * 3 - pos[1] - 1]
      n_dir = 2
    else 
      raise "Unexpected move #{[dx,dy].inspect} from #{pos.inspect}"
    end
  when [0,1]
    case [dx,dy]
    when [0, -1]
      # to sq 1 up
      n_pos = [sq_size * 3 - pos[0] - 1, 0]
      n_dir = 1
    when [-1, 0]
      # to sq 6, up
      n_pos = [sq_size * 5 - pos[1], sq_size * 3 - 1]
      n_dir = 3
    when [0, 1]
      # to sq 5 up
      n_pos = [sq_size * 3 - pos[0] - 1, sq_size * 3 - 1]
      n_dir = 3
    else 
      raise "Unexpected move #{[dx,dy].inspect} from #{pos.inspect}"
    end
  when [1,1]
    # sq 3
    case dy
    when -1
      # sq 1 right
      n_pos = [2 * sq_size, pos[0] - sq_size]
      n_dir = 0
    when 1
      # sq 5 right
      n_pos = [2 * sq_size, sq_size * 4 - pos[0] - 1]
      n_dir = 0
    else 
      raise "Unexpected move #{[dx,dy].inspect} from #{pos.inspect}"
    end
  when [2, 1]
    # sq 4
    n_pos = [5 * sq_size - pos[1] - 1, sq_size * 2]
    n_dir = 1
  when [2, 2]
    # sq 5
    if dx == -1
      n_pos = [sq_size * 4 - pos[1] - 1, sq_size * 2 - 1]
      n_dir = 3
    elsif dy == 1
      n_pos = [sq_size * 3 - pos[0] - 1, sq_size * 2 - 1]
      n_dir = 3
    else 
      raise "Unexpected shift at #{pos.inspect} delta: [#{dx}, #{dy}]"
    end
  when [3,2]
    # sq 6
    case [dx, dy]
    when [0, -1]
      n_pos = [sq_size * 3 - 1, sq_size * 5 - 1 - pos[0]]
      n_dir =  2
    when [1, 0]
      n_pos = [sq_size * 3 - 1, sq_size * 3 - 1 - pos[1]]
      n_dir =  2
    when [0, 1]
      n_pos = [0, sq_size * 5 - 1 - pos[0]]
      n_dir = 0
    else
      raise "Unexpected shift at #{pos.inspect} delta: [#{dx}, #{dy}]"
    end
    # DIRS = [[1,0], [0,1], [-1,0], [0, -1]]
  else
    binding.break
    raise "In weird place #{pos.inspect} #{[pos[0] / sq_size, pos[1] / sq_size].inspect}"
  end
  [n_pos, n_dir]
end
map, _, _ = parse(SAMPLE)
# Sq 1
assert_equal([[10, 11], 3], calc(map, [10,0], 0, -1))
assert_equal([[15, 11], 2], calc(map, [11,0], 1, 0))
assert_equal([[15,  9], 2], calc(map, [11,2], 1, 0))
assert_equal([[ 6,  4], 2], calc(map, [8,2], -1, 0))

# sq 2
assert_equal([[11, 0], 1], calc(map, [0, 4], 0, -1))
assert_equal([[ 9, 0], 1], calc(map, [2, 4], 0, -1))
assert_equal([[15,11], 3], calc(map, [0, 5], -1, 0))
assert_equal([[14,11], 3], calc(map, [0, 6], -1, 0))
assert_equal([[11,11], 3], calc(map, [0, 7],  0, 1))
assert_equal([[ 9,11], 3], calc(map, [2, 7],  0, 1))

# sq 3
assert_equal([[8,  0], 0], calc(map, [4, 4], 0,-1))
assert_equal([[8,  3], 0], calc(map, [7, 4], 0,-1))
assert_equal([[8, 11], 0], calc(map, [4, 7], 0, 1))
assert_equal([[8,  8], 0], calc(map, [7, 7], 0, 1))

# sq 4
assert_equal([[15, 8], 1], calc(map, [11, 4], 1, 0))
assert_equal([[12, 8], 1], calc(map, [11, 7], 1, 0))
assert_equal([[14, 8], 1], calc(map, [11, 5], 1, 0))

# sq 5
assert_equal([[7, 7], 3], calc(map, [8, 8], -1, 0))
assert_equal([[5, 7], 3], calc(map, [8, 10], -1, 0))
assert_equal([[0, 7], 3], calc(map, [11, 11], 0, 1))
assert_equal([[3, 7], 3], calc(map, [8, 11], 0, 1))

# sq 6
assert_equal([[11, 7], 2], calc(map, [12, 8], 0, -1))
assert_equal([[11, 4], 2], calc(map, [15, 8], 0, -1))

assert_equal([[11, 3], 2], calc(map, [15, 8], 1, 0))
assert_equal([[11, 0], 2], calc(map, [15,11], 1, 0))

assert_equal([[0, 7], 0], calc(map, [12, 11], 0, 1))
assert_equal([[0, 4], 0], calc(map, [15, 11], 0, 1))


# assert_equal(6032, part1(SAMPLE))
# puts "Part 1: #{part1(DATA)}"
assert_equal(5031, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"
# # map, _, _ = parse(DATA)
# # dump(map, {})
# # puts map.first.inspect
