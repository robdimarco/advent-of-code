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

Room = Struct.new(:name, :rate, :destinations) do
  def valve?
    rate > 0
  end
end

def parse(data)
  h = data.lines.each_with_object({}) do |line, hsh|
    tokens = line.split(' ')
    hsh[tokens[1]] = 
      Room.new(
        tokens[1], 
        tokens[4].scan(/\d+/).first.to_i, 
        tokens[9..-1].map {|t| t.gsub(',', '')}
      )
  end
  Routes.new(h)
end

class Routes
  attr_reader :rh, :all_paths
  def initialize(room_hash)
    @rh = room_hash
    @all_paths = find_all_paths
  end

  def shortest_path(from, to, path=[], distances={})
    return path + [from] if from == to
    opts = rh[from].destinations.reject {|d| path.include?(d)}
    opts.map {|d| shortest_path(d, to, path + [from])}.compact.min_by(&:size)
  end

  def valve_rooms
    @valve_rooms ||= rh.values.select(&:valve?).map(&:name)
  end

  def find_all_paths
    vs = (valve_rooms + ['AA']).uniq
    vs.each_with_object({}) do |a, hsh|
      hsh[a] ||= {}
      vs.each do |b|
        hsh[b] ||= {}
        hsh[a][b] = shortest_path(a, b) unless a == b
      end
    end
  end
end

State = Struct.new(:room, :valves, :time_remaining, :routes) do
  def room_hash
    routes.rh
  end

  def key
    [room, valves]
  end

  def valve_closed?
    room_hash[room].valve? && valves[room].nil?
  end

  def next_steps
    @next_steps ||= routes.all_paths[room].reject {|k, _| valves[p]}
  end
  
  def next_states
    next_states = []
    if valve_closed?
      next_states.push(
        State.new(
          room, 
          valves.merge({room => time_remaining - 1}), 
          time_remaining - 1, 
          routes
        )
      )
    end
    next_states += next_steps.map do |(nr, path)|
      State.new(
        nr, 
        valves, 
        time_remaining - path.size + 1, 
        routes
      )
    end.compact
    next_states
  end

  def actual
    @actual ||= valves.keys.sum {|v| room_hash[v].rate * valves[v]}
  end

  def unrealized
    return @unrealized if @unrealized
    vals = routes.valve_rooms.map {|v| room_hash[v].rate}
    @unrealized = vals.sum {|v| v * time_remaining}
  end

  def potential
    @potential ||= unrealized + actual
  end

  def done?
    time_remaining <= 0 || next_steps.empty?
  end

  def rate
    room_hash[room].rate
  end
end

def run(routes, s)
  to_check = Containers::PriorityQueue.new
  to_check.push(s, [s.potential, s.actual])
  best = 0
  best_seen = 0
  visited = Set.new
  while !to_check.empty?
    state = to_check.pop
    next if visited.include?(state.key)
    visited.add(state.key)
    puts "best: #{best} bs: #{best_seen} queue: #{to_check.size} pot: #{state.potential} act: #{state.actual} v: #{visited.size} mv: #{state.next_steps.size}" if visited.size % 10_000 == 0
    if state.done?
      if best < state.actual
        puts "Setting best from #{best} to #{state.actual}" 
        best = state.actual
      end
      next
    end
    return best if best > state.potential
    next if state.potential < best_seen
    best_seen = state.actual if state.actual > best_seen

    state.next_states.each do |s|
      # binding.break
      to_check.push(s, [s.potential, s.actual]) 
    end
  end

  best
end

def part1(input, time = 30)
  routes = parse(input)

  s = State.new('AA', {}, time, routes)
  run(routes, s)
end

# assert_equal(0, part1(SAMPLE, 1))
# assert_equal(0, part1(SAMPLE, 2))
# assert_equal(20, part1(SAMPLE, 3))
# assert_equal(40, part1(SAMPLE, 4))
# assert_equal(63, part1(SAMPLE, 5))
# assert_equal(1651, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

# def part2(input, time = 26)
#   room_hash = parse(input)
#   s = StatePart2.new('AA', 'AA', {}, time, room_hash)
#   run(room_hash, s)
# end

# assert_equal(1707, part2(SAMPLE))
# puts "Part 2: #{part2(DATA)}"