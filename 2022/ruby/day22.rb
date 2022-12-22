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

assert_equal(6032, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"
# map, _, _ = parse(DATA)
# dump(map, {})
# puts map.first.inspect
