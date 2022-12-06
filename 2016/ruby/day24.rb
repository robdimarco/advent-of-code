def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day24.txt')
SAMPLE = <<~TEXT
###########
#0.1.....2#
#.#######.#
#4.......3#
###########
TEXT

def parse(data)
  grid = data.lines.map do |l|
    l.strip.chars
  end
  points = {}
  grid.size.times do |y|
    row = grid[y]
    row.size.times do |x|
      if row[x] =~ /\d/
        points[row[x].to_i] = [x, y]
      end
    end
  end

  [grid, points]
end

def distance(p1, p2)
  (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

require 'algorithms'
def shortest_distance(p1, p2, grid)
  queue ||= Containers::PriorityQueue.new
  queue.push([p1], 0)
  rv = nil
  visited = {}
  until queue.empty?
    path = queue.pop
    pos = path[-1]
    # puts "Checking #{pos}"
    if pos == p2 
      # puts "Found path of length #{path.size - 1} for #{p1.inspect} to #{p2.inspect} from #{path.inspect}"
      rv = [rv, path.size - 1].compact.min
      next
    end
    dist = distance(pos, p2)
    next if !rv.nil? && rv < path.size - 1 + dist
    next if visited[pos] && visited[pos] <= path.size
    visited[pos] = path.size

    puts "queue: #{queue.size} path: #{path.size - 1} distance: #{dist} current: #{rv}" if rand(1000) == 0

    [[0,1], [1,0],[-1, 0], [0, -1]].each do |dx, dy|
      x = pos[0] + dx
      y = pos[1] + dy

      # OOB
      next if (x < 0 || x >= grid[0].size) || (y < 0 || y >= grid.size)

      # wall
      next if grid[y][x] == '#'

      new_pos = [x, y]
      next if path.include?(new_pos)
      new_path = path + [new_pos]
      queue.push(new_path, [-1 * distance(new_pos, p2), -1 * new_path.size])
    end
  end

  rv
end

def fewest_steps(data, and_back = false)
  grid, points = parse(data)

  point_distances = {}
  points.keys.combination(2).each do |(a, b)|
    # puts "Calculating for #{a} to #{b}"
    point_distances[[a,b].sort] = shortest_distance(points[a], points[b], grid)
  end

  mins = points.keys.permutation.map do |perm|
    next unless perm[0] == 0
    perm = perm + [0] if and_back
    d = (1...perm.size).sum do |n|
      key = [perm[n-1], perm[n]].sort
      point_distances[key] 
    end
    [d, perm]
  end.compact
  # pp mins.sort

  mins.map(&:first).min
end

assert_equal(14, fewest_steps(SAMPLE))
# puts "Part 1: #{fewest_steps(DATA)}"
puts "Part 2: #{fewest_steps(DATA, true)}"