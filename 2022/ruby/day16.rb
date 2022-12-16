def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
# require 'algorithms'
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
  # def paths(room_hash, current_path = [])
  #   @paths ||= {}
  #   return @paths[[name, current_path]] if @paths[[name, current_path]]
  #   avail = destinations.reject {|nr| current_path.include?(nr)}
  #   next_path = current_path + [name]
  #   rv = if avail.any?
  #     avail.flat_map {|nr| room_hash[nr].paths(room_hash, next_path)}
  #   else
  #     [next_path]
  #   end

  #   @paths[[name, current_path]] = rv
  #   rv
  # end
end

def parse(data)
  data.lines.each_with_object({}) do |line, hsh|
    tokens = line.split(' ')
    hsh[tokens[1]] = 
      Room.new(
        tokens[1], 
        tokens[4].scan(/\d+/).first.to_i, 
        tokens[9..-1].map {|t| t.gsub(',', '')}
      )
  end
end

State = Struct.new(:room, :valves, :time_remaining, :room_hash) do
  def key
    [room, valves, time_remaining]
  end

  def valve_closed?
    valves[room].nil?
  end

  def next_steps
    room_hash[room].destinations
  end
  
  def next_states
    next_states = []
    if valve_closed? && room_hash[room].rate > 0
      next_states.push(
        State.new(
          room, 
          valves.merge({room => time_remaining - 1}), 
          time_remaining - 1, 
          room_hash
        )
      )
    end

    next_states += next_steps.map do |nr|
      State.new(
        nr, 
        valves, 
        time_remaining - 1, 
        room_hash
      )
    end.compact
    next_states
  end

  def missing_valves
    @missing_valves ||= room_hash.keys.select {|r| room_hash[r].rate > 0} - valves.keys
  end

  def actual
    @actual ||= valves.keys.sum {|v| room_hash[v].rate * valves[v]}
  end

  def unrealized
    return @unrealized if @unrealized
    vals = missing_valves.map {|v| room_hash[v].rate}
    @unrealized = vals.sum {|v| v * time_remaining}
  end

  def potential
    @potential ||= unrealized + actual
  end

  def done?
    time_remaining == 0 || missing_valves.empty?
  end

  def rate
    room_hash[room].rate
  end
end

def part1(input, time = 30)
  room_hash = parse(input)
  require 'algorithms'
  to_check = Containers::PriorityQueue.new
  s = State.new('AA', {}, time, room_hash)
  to_check.push(s, [s.potential, s.actual])
  best = 0
  best_seen = 0
  require 'set'
  visited = Set.new
  while !to_check.empty?
    state = to_check.pop
    next if visited.include?(state.key)
    visited.add(state.key)
    puts "best: #{best} bs: #{best_seen} queue: #{to_check.size} pot: #{state.potential} act: #{state.actual} v: #{visited.size} mv: #{state.missing_valves.size}" if visited.size % 10_000 == 0
    if state.done?
      if best < state.actual
        puts "Setting best from #{best} to #{state.actual}" 
        best = state.actual
      end
      next
    end
    next if state.potential < best_seen
    best_seen = state.actual if state.actual > best_seen

    state.next_states.each do |s|
      if s.potential > best
        to_check.push(s, [s.potential, s.actual]) 
      end
    end
  end
  best
end

assert_equal(0, part1(SAMPLE, 1))
assert_equal(0, part1(SAMPLE, 2))
assert_equal(20, part1(SAMPLE, 3))
assert_equal(40, part1(SAMPLE, 4))
assert_equal(63, part1(SAMPLE, 5))
assert_equal(1651, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"

def part2(input)
end

# assert_equal(56000011, part2(SAMPLE))
# puts "Part 2: #{part2(DATA, 4000000)}"