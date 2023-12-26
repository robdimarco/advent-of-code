sample=<<~TXT.lines.map(&:strip).map(&:chars)
#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
TXT
real = File.open("day23.txt").read.lines.map(&:strip).map(&:chars)

require 'set'
def valid?(pos, data)
  row, col = pos
  row >= 0 && row < data.size && col >= 0 && col < data[row].size && data[row][col] != '#'
end

def moves(pos, data, slippery = true)
  row, col = pos
  if slippery
    case data[row][col]
    when '^'
      [[-1, 0]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}
    when '>'
      [[0, 1]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}
    when '<'
      [[0, -1]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}
    when 'v'
      [[1, 0]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}
    else
      [[0, 1], [1, 0], [-1, 0], [0, -1]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}.select {|pos| valid?(pos, data)}
    end
  else
    [[0, 1], [1, 0], [-1, 0], [0, -1]].map {|(dr, dc)| [pos[0] + dr, pos[1] + dc]}.select {|pos| valid?(pos, data)}
  end
end

require 'algorithms'
require 'set'

def run(data, slippery)
  start_pos = [0, data[0].index('.')]
  end_pos = [data.size - 1, data[-1].index('.')]

  graph = build_graph(data, start_pos, slippery)
  walk_graph(start_pos, end_pos, graph)
  # v = paths.sort_by {|path| path.map(&:size).sum}.last
  # # puts v.map(&:export)
  # v.map(&:size).sum
end

Line = Struct.new(:start_pos, :end_pos, :path) do
  def size
    path.size - 1
  end

  def push(pos)
    self.end_pos = pos
    self.path.push(pos)
    self
  end

  def export
    "#{start_pos} -> #{end_pos} #{size}"
  end
end

def build_graph(data, start, slippery)
  graph = Hash.new {|h, k| h[k] = []}

  l = Line.new(start, start, [start])
  graph[start].push(l)
  to_check = [l]
  i = 0
  until to_check.empty? do
    l = to_check.shift
    # puts "Looking at #{l.start_pos} to #{l.end_pos} q(#{to_check.size})"

    m = moves(l.end_pos, data, slippery).reject {|np| l.path.include?(np)}
    if m.size == 1
      l.push(m.first)
      to_check.push(l)
      # puts "  Extended #{l.start_pos} to #{l.end_pos} q(#{to_check.size})"
      next
    end

    m.each do |pos|
      ll = Line.new(l.end_pos, pos, [l.end_pos, pos])
      cur = graph[ll.start_pos]
      unless cur.any? {|curl| curl.path.include?(pos)}
        cur.push(ll)
        to_check.push(ll)
        # puts "  New line #{ll.start_pos} to #{ll.end_pos} q(#{to_check.size})"
      else
        # puts "  Already traversed, skipping"
      end
    end
  end
  # graph.values.map(&:uniq!)
  graph
end

def walk_graph(start_pos, end_pos, graph)
  to_check = [] # Containers::PriorityQueue.new
  to_check.push([start_pos, 0, []])
  max_size = 0
  until to_check.empty?
    pos, steps, checked = to_check.pop
    # puts "Checking #{pos}"
    if pos == end_pos
      if steps > max_size
        max_size = steps
        puts "Have max size #{max_size}"
      end
      next
    end
    graph[pos].each do |l|
      epos = l.end_pos
      unless checked.include?(epos)
        to_check.push([epos, steps + l.size, checked + [pos]])
      end
    end
  end
  max_size
  #   lines.each do |l|
  #     nl = graph[l.end_pos]
  #     if nl.empty?
  #       if l.end_pos == end_pos
  #         end_path = path + [l]
  #         length = end_path.map(&:size).sum
  #         if length > max_size
  #           paths = [end_path]
  #           max_size = length
  #           puts "Adding path of length #{length}"
  #         end
  #       end
  #       next
  #     end

  #     unless path.any? {|ll| ll.start_pos == l.end_pos || ll.start_pos == l.start_pos}
  #       new_path = path + [l]
  #       unless checked.include?(new_path)
  #         to_check.push([nl, new_path], new_path.map(&:size).sum) 
  #         checked.add(new_path)
  #       else
  #         skipped += 1
  #       end
  #     else
  #       duped += 1
  #       # puts "Skipping #{l.export} on path #{path.map(&:export)}" if duped % 1000 == 0
  #     end
  #   end
  # end
end

def part1(data)
  run(data, true)
end
def part2(data)
  run(data, false)
end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real)