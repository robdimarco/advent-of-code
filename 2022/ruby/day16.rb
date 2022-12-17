def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'

DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
TEXT

# Have nodes and edges
Node = Struct.new(:name, :rate)
# Edge = Struct.new
def parse(input)
  re = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/
  nodes = {}
  edges = {}
  input.lines.map do |l|
    m = re.match(l.strip)

    n = m[1]
    r = m[2]
    v = m[3]
    nodes[n] = Node.new(n, r.to_i)
    edges[n] = v.split(', ')
  end

  node_to_edges = {}
  edges.each do |(n, vals)|
    node_to_edges[nodes[n]] = {}
    vals.each do |v|
      binding.break if nodes[v].nil?
      node_to_edges[nodes[n]][nodes[v]] = 1
    end
  end
  start_node = nodes['AA']
  [start_node, find_all_paths(node_to_edges, start_node)]
end

def find_paths(edges, goal)
  q = Containers::Queue.new
  q.push([0, goal])
  path_lengths = {goal => 0}
  while !q.empty? do
    cost, current = q.pop
    edges[current].each do |(point, point_cost)|
      if !path_lengths.include?(point) || cost + point_cost < path_lengths[point]
        path_lengths[point] = cost + point_cost

        q.push([cost + point_cost, point])
      end
    end
  end
  path_lengths
end

def find_all_paths(edges, start_node)
  costs = {}
  edges.each do |(node, _)|
    costs[node] = find_paths(edges, node) if node == start_node || node.rate > 0
  end
  rv = {}
  costs.each do |(node, node_costs)|
    rv[node] = {}
    node_costs.each do |(x, c)|
      rv[node][x] = c if x.rate > 0
    end
  end
  rv
end

def run_order(costs, start_node, nodes, t)
  release = 0
  current = start_node
  nodes.each do |node|
    cost = costs[current][node] + 1
    t -= cost
    release += t * node.rate
    current = node
  end
  release
end

def all_orders(distances, node, todo, done, time)
  Enumerator.new do |y|
    todo.each do |next_node|
      # binding.break if distances[node][next_node].nil?
      cost = distances[node][next_node] + 1
      if cost < time
        all_orders(distances, next_node, todo - [next_node], done + [next_node],time - cost).each do |n|
          y.yield n
        end
      end
    end
    y.yield done
  end
end

def part1(input)
  start_node, distances = parse(input)
  working_nodes = distances.keys.select {|n| n.rate > 0}.uniq

  p1_orders = all_orders(distances, start_node, working_nodes, [], 30)
  best_value = p1_orders.map {|order| run_order(distances, start_node, order, 30)}.max
  best_value
end

def part2(input)
  start_node, distances = parse(input)
  working_nodes = distances.keys.select {|n| n.rate > 0}.uniq

  p2_orders = all_orders(distances, start_node, working_nodes, [], 26)
  p2_scores = p2_orders.map do |order|
    [run_order(distances, start_node, order, 26), order.uniq]
  end
  p2_scores.sort_by! {|x| -x[0]}
  # binding.break
  best = 0
  p2_scores.each_with_index do |(sa, oa), i|
    if sa * 2 < best
      break
    end
    p2_scores[i+1..-1].each do |(sb, ob)|
      # binding.break if sa + sb = 1707

      if (oa & ob).empty?
        score = sa + sb
        if score > best
          # binding.break
          best = score
        end
      end
    end
  end
  best
end
# assert_equal(1651, part1(SAMPLE))
# puts "Part 1: #{part1(DATA)}"
# assert_equal(1707, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"
