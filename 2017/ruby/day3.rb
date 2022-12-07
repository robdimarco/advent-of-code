def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

DATA = 325489

def steps(input)
  i = (input ** 0.5).ceil
  i +=1 if i.even?
  # puts "Got #{i} for #{input}"

  number = i**2
  pos = [i - 1, i - 1]
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

  return (pos[0] - (i/2)).abs + (pos[1] - (i/2)).abs
end

assert_equal(0, steps(1))
assert_equal(2, steps(11))
assert_equal(2, steps(19))
assert_equal(3, steps(12))
assert_equal(2, steps(23))
assert_equal(31, steps(1024))


puts "Part 1 #{steps(DATA)}"