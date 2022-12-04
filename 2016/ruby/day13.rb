def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

def wall?(seed, point)
  x, y = point
  v = x*x + 3*x + 2*x*y + y + y*y + seed
  v.to_s(2).chars.count {|n| n == '1'}.odd?
end

assert_equal(false, wall?(10, [0,0]))
assert_equal(false, wall?(10, [0,1]))
assert_equal(true, wall?(10, [1,0]))

def shortest_path(seed, destination)
  to_check = [[[1,1], []]]

  while to_check.any? do
    pos, current_path = to_check.shift
    # puts "Checking #{pos.inspect} on #{current_path.inspect}"
    if destination == pos
      return current_path.size
    end
    pos_x, pos_y = pos
    [[1,0], [0, 1], [-1, 0], [0, -1]].each do |(dx, dy)|
      new_pos = [pos_x + dx, pos_y + dy]
      next if new_pos[0] < 0 || new_pos[1] < 0 || wall?(seed, new_pos) || current_path.include?(new_pos)

      to_check.push([new_pos, [new_pos] + current_path])
    end
  end  
  nil
end

assert_equal(11, shortest_path(10, [7,4]))
puts "Part 1: #{shortest_path(1350, [31, 39])}"