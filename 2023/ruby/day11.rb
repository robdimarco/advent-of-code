require 'algorithms'
require 'set'

sample=<<~TXT.lines.map(&:strip)
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
TXT



real = File.open("day11.txt").read.lines.map(&:strip)

class Part1
  attr_reader :data, :empty_cols, :empty_rows
  def initialize(lines)
    @data = lines.map(&:chars)
    @empty_rows = Set.new
    @data.each_with_index do |r, idx|
      @empty_rows.add(idx) if r.uniq == ['.']
    end
    @empty_cols = Set.new
    @data[0].size.times do |col|
      f = false
      @data.each do |row|
        if row[col] != '.'
          f = true
          break
        end
      end
      @empty_cols.add(col) unless f
    end
  end
  def dist(a, b)
    (a[0] - b[0]).abs + (a[1] - b[1]).abs
  end

  def shortest_path(start, destination, base_cost)
    to_check = Containers::PriorityQueue.new
    to_check.push([start, Set.new, 0], -1 * dist(start, destination))

    cache = {}
    # puts "Looking for #{start} to #{destination}"
    print '.'
    until to_check.empty? do
      pos, current_path, cost = to_check.pop
      # puts "Checking #{pos} fro #{current_path} at #{cost}"
      # puts "checking #{pos} in #{current_path} trying to get to #{destination}"
      next if current_path.include?(pos)
      break if destination == pos

      row, col = pos
      [[1,0], [0, 1], [-1, 0], [0, -1]].each do |(dr, dc)|
        rr = row + dr
        cc = col + dc
        next if rr < 0 || cc < 0 || rr >= data.size || cc >= data[0].size

        new_pos = [rr, cc]
        nc = 1
        nc += base_cost if dr != 0 && empty_rows.include?(rr)
        nc += base_cost if dc != 0 && empty_cols.include?(cc)

        if cache[new_pos].nil? || cache[new_pos] > cost + nc
          cache[new_pos] = cost + nc
          to_check.push([new_pos, Set.new(pos) + current_path, cost + nc], -1 * dist(new_pos, destination))
        end
      end
    end  

    cache[destination]
  end

  def points
    rv = []
    data.each_with_index do |r, row|
      r.each_with_index do |c, col|
        rv.push([row, col]) if c == '#'
      end
    end
    rv
  end
end

def part1(lines)
  p1 = Part1.new(lines)
  p1.points.combination(2).map do |(a, b)|
    p1.shortest_path(a, b, 1)
  end.sum
end

def part2(lines, cost)
  p1 = Part1.new(lines)
  p1.points.combination(2).map do |(a, b)|
    p1.shortest_path(a, b, cost)
  end.sum
end

puts part1(sample).inspect
# puts part1(real)


# def part2(lines)
# end

puts part2(sample, 9)
puts part2(sample, 99)
puts part2(real, 999_999)
# puts part2(real)
