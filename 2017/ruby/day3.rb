def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

DATA = 325489

def place_in_grid(input)
  i = (input ** 0.5).ceil
  i +=1 if i.even?
  # puts "Got #{i} for #{input}"

  number = i**2
  pos = [i - 1 - (i/2), i - 1 - (i/2)]
  # puts "Have total number of #{number}"

  (number - input).times do |n|

    if n < i - 1
      pos[0] -= 1
      # puts "Moving left"
    elsif n < 2*i - 2
      pos[1] -= 1
      # puts "Moving up"
    elsif n < 3*i - 3
      pos[0] += 1
      # puts "Moving right"
    else
      pos[1] += 1
      # puts "Moving down"
    end
  end
  # puts "Comparing #{pos.inspect} to #{[i/2, i/2]}"
  return [pos, [0, 0]]
end

def steps(input)
  pos, center = place_in_grid(input)
  return (pos[0] - center[0]).abs + (pos[1] - center[1]).abs
end

assert_equal(0, steps(1))
assert_equal(2, steps(11))
assert_equal(2, steps(19))
assert_equal(3, steps(12))
assert_equal(2, steps(23))
assert_equal(31, steps(1024))


puts "Part 1 #{steps(DATA)}"

def greater_sum(input)
  i = 1
  cmp = 0
  grid = {[0,0] => 1}
  dim = 0
  while cmp < input
    i += 1
    pos, _ = place_in_grid(i)
    val = [[0,1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]].sum do |(x, y)|
      grid[[pos[0] +x, pos[1] + y]].to_i
    end
    # puts "#{pos} from #{i} has val #{val}"

    cmp = grid[pos] = val
    # break if i > 10
  end
  # puts grid.inspect
  cmp
end

assert_equal(25, greater_sum(24))
assert_equal(806, greater_sum(800))
puts "Part 2 #{greater_sum(DATA)}"