sample=<<~TXT.lines.map(&:strip).map {|l| l.chars.map(&:to_i)}
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
TXT

real = File.open("day17.txt").read.lines.map(&:strip).map {|l| l.chars.map(&:to_i)}
require 'algorithms'

State = Struct.new(:node, :heat) do
  def priority
    [-heat]
  end

  def next(dr, dc, heats)
    same_dir = node.pr == dr && node.pc == dc
    return nil if node.steps == 2 && same_dir

    nr = node.r + dr
    nc = node.c + dc
    return nil if nr < 0 || nc < 0 || nr >= heats.size || nc >= heats[0].size
    h = heat + heats[nr][nc]
    State.new(Node.new(nr, nc, dr, dc, same_dir ? node.steps + 1 : 0), h)
  end

  def next_ultra(dr, dc, heats)
    same_dir = node.pr == dr && node.pc == dc
    return nil if node.steps == 9 && same_dir
    return nil if node.steps < 3 && !same_dir

    nr = node.r + dr
    nc = node.c + dc
    return nil if nr < 0 || nc < 0 || nr >= heats.size || nc >= heats[0].size
    h = heat + heats[nr][nc]
    State.new(Node.new(nr, nc, dr, dc, same_dir ? node.steps + 1 : 0), h)
  end
end

Node = Struct.new(:r, :c, :pr, :pc, :steps)

def part1(data)
  max_r = data.size - 1 
  max_c = data[0].size - 1 
  visited = Set.new
  visited.add(Node.new(0, 0, 0, -1, 0))
  visited.add(Node.new(0, 0, -1, 0, 0))
  queue = Containers::PriorityQueue.new
  s = State.new(Node.new(1, 0, 1, 0, 0), data[1][0])
  queue.push(s, s.priority)

  s = State.new(Node.new(0, 1, 0, 1, 0), data[0][1])
  queue.push(s, s.priority)
  last_cost = max_r * max_c * 9

  until queue.empty?
    state = queue.pop
    next if visited.include?(state.node)
    visited.add(state.node)
    return state.heat if state.node.r == max_r && state.node.c == max_c

    ([[1, 0], [0, 1], [-1, 0], [0, -1]] - [[-state.node.pr, -state.node.pc]]).each do |(dr, dc)|
      nstate = state.next(dr, dc, data)

      if nstate && !visited.include?(nstate.node)
        queue.push(nstate, nstate.priority) 
      end
    end
  end
  -1
end

def part2(data)
  max_r = data.size - 1 
  max_c = data[0].size - 1 
  visited = Set.new
  visited.add(Node.new(0, 0, 0, -1, 0))
  visited.add(Node.new(0, 0, -1, 0, 0))
  queue = Containers::PriorityQueue.new
  s = State.new(Node.new(1, 0, 1, 0, 0), data[1][0])
  queue.push(s, s.priority)

  s = State.new(Node.new(0, 1, 0, 1, 0), data[0][1])
  queue.push(s, s.priority)
  last_cost = max_r * max_c * 9

  until queue.empty?
    state = queue.pop
    next if visited.include?(state.node)
    visited.add(state.node)
    return state.heat if state.node.r == max_r && state.node.c == max_c && state.node.steps > 2

    ([[1, 0], [0, 1], [-1, 0], [0, -1]] - [[-state.node.pr, -state.node.pc]]).each do |(dr, dc)|
      nstate = state.next_ultra(dr, dc, data)

      if nstate && !visited.include?(nstate.node)
        queue.push(nstate, nstate.priority) 
      end
    end
  end
  -1
end

puts part1(sample)
puts part1(real)

puts part2(sample)
sample_2=<<~TXT.lines.map(&:strip).map {|l| l.chars.map(&:to_i)}
111111111111
999999999991
999999999991
999999999991
999999999991
TXT
puts part2(sample_2)
puts part2(real)

