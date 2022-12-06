def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day22.txt')
SAMPLE = <<~TEXT
Filesystem            Size  Used  Avail  Use%
/dev/grid/node-x0-y0   10T    8T     2T   80%
/dev/grid/node-x0-y1   11T    6T     5T   54%
/dev/grid/node-x0-y2   32T   28T     4T   87%
/dev/grid/node-x1-y0    9T    7T     2T   77%
/dev/grid/node-x1-y1    8T    0T     8T    0%
/dev/grid/node-x1-y2   11T    7T     4T   63%
/dev/grid/node-x2-y0   10T    6T     4T   60%
/dev/grid/node-x2-y1    9T    8T     1T   88%
/dev/grid/node-x2-y2    9T    6T     3T   66%
TEXT
Node = Struct.new(:x, :y, :total, :used, :avail) do
  def empty?
    used == 0
  end
end

def parse(line)
  match = /node\-x(\d+)\-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/.match(line)
  return unless match
  Node.new(match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i, match[5].to_i)
end
# assert_equal(Node.new(0, 0, 87, 71, 16), parse("/dev/grid/node-x0-y0     87T   71T    16T   81%"))

def nodepairs(nodes)
  rv = []
  nodes.each do |a|
    nodes.each do |b|
      if !a.empty? && a != b && a.used <= b.avail
        rv.push([a,b])
      end
    end
  end
  rv
end

def pairs(data)
  nodes = data.lines.map{|l| parse(l)}.compact
  nodepairs(nodes).size
end


# assert_equal(7, pairs(SAMPLE))
# puts "Part 1: #{pairs(DATA)}"

State = Struct.new(:data_pos, :nodes, :path) do
  def key
    @key ||= [data_pos, nodes.map(&:avail)]
  end 

  def connected_pairs
    nodepairs(nodes).select do |(a,b)|
      ((a.x - b.x).abs == 1 && a.y == b.y) || ((a.y - b.y).abs == 1 && a.x == b.x)
    end
  end

  def next_states
    connected_pairs.sort_by{|(a,b)| a.used}.flat_map do |(a, b)|
      next_nodes = nodes.map do |n|
        if n == a
          Node.new(a.x, a.y, a.total, 0, a.total)
        elsif n == b
          Node.new(b.x, b.y, b.total, b.used + a.used, b.total - b.used - a.used)
        else
          n
        end
      end
      dp = [b.x, b.y] if data_pos == [a.x, a.y]
      State.new(dp || data_pos, next_nodes, path + [self])
    end
  end

  def done?
    data_pos == [0,0]
  end
end


def find_min_steps(state, visited, lowest = nil)
  if state.done?
    # puts "hit"
    return state.path.size 
  end
  return :skip if visited[state.key] && visited[state.key] < state.path.size
  return :skip if lowest && state.path.size > lowest
  visited[state.key] = state.path.size
  puts "visited #{visited.size} path #{state.path.size} pos #{state.data_pos}" if rand(100) == 0
  # raise "Path too big" if state.path.size > 20
  # print 'a'
  nss = state.next_states
  return :none if nss.empty?
  nss.map do |ns|
    next if visited[ns.key] && visited[ns.key] < ns.path.size
    ms = find_min_steps(ns, visited, lowest)
    lowest = ms if ms && ms != :none && ms != :skip && (lowest.nil? || ms < lowest)
  end

  lowest
end

def minsteps(data)
  nodes = data.lines.map{|l| parse(l)}.compact
  data_pos = [nodes.map(&:x).max, 0]
  state = State.new(data_pos, nodes, [])

  visited = {}
  find_min_steps(state, visited)
end

def printgrid(data)
  nodes = data.lines.map{|l| parse(l)}.compact.sort_by {|n| [n.x, n.y]}
  width = nodes.map(&:y).max
  hgt = nodes.map(&:x).max
  hole = nodes.detect {|n| n.used == 0}
  puts "Grid: " + [width, hgt].inspect + "Hole at #{[hole.y, hole.x]}"
  nodes.map do |n|
    # puts [n.x, n.y].inspect
    if n.y == 0 
      puts
      print '| '
    end
    if n.used == 0
      print ' [0]'
    else
      print ('    ' + n.used.to_s)[-4..-1]
    end
  end
  puts

  # Find the hole
  # Calculate how far to move it to the bottom corner
  # Add in 6 to get around the wall in the middle (can see wall from print out
  # 5 moves to move data up 1 spot vertically (from the example)
  puts hgt - hole.x + hole.y + 5 * (hgt - 1) + 6 d

SAMPLE_TINY = State.new(
  [1, 0], 
  [
    Node.new(0, 0, 10, 8, 2),
    Node.new(0, 1, 11, 6, 5),
    Node.new(1, 0, 9, 7, 2),
    Node.new(1, 1, 8, 0, 8)
  ],
  []
)

# 8/2 6/5    8/2 11/0    10/0  9/2     3/7
# 7/2 0/8 -> 7/2  5/3 ->  7/2  5/3 ->

# assert_equal(3, nodepairs(SAMPLE_TINY.nodes).size)
# assert_equal(2, SAMPLE_TINY.connected_pairs.size)

# assert_equal(2, SAMPLE_TINY.next_states.size)
# ns1 = SAMPLE_TINY.next_states[0]
# # puts ns1

# assert_equal(3, nodepairs(ns1.nodes).size)
# assert_equal(2, ns1.connected_pairs.size)
# # puts ns1.key.inspect
# assert_equal([[1,0],[2, 11, 2, 2]], ns1.key)
# assert_equal([1, 0], ns1.data_pos)
# # ns2 = ns1.next_states.first
# # puts ns2.key.inspect

# assert_equal(3, find_min_steps(SAMPLE_TINY, {}))

# assert_equal(7, minsteps(SAMPLE))
# puts "Part 2: #{minsteps(DATA)}"
printgrid(DATA)
