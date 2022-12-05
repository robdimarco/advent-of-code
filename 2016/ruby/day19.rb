def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

input = 3012210

def winner(positions)
  pos = 0
  ar = (1..positions).to_a
  while ar.size > 1 do
    kept = []
    rejected = []
    ar.each_with_index do |n, idx|
      bucket = idx.odd? ? rejected : kept
      bucket.push(n)
    end
    # puts "AR: #{ar.inspect}, rej: #{rejected.inspect}"

    return rejected[-1] if ar.empty?
    kept.shift if ar.size.odd?
    ar = kept
  end
  ar[0]
end

assert_equal(3, winner(5))
# puts "Part 1: #{winner(input  )}"
require 'algorithms'
def winner_part2(positions)
  cut = (positions + 1) / 2
  left = Containers::CDeque.new((1..cut).to_a)
  right = Containers::CDeque.new(((cut+1)..positions).to_a.reverse)
 
  while (left.size + right.size) > 1
    if left.size > right.size
      left.pop_back
    else
      right.pop_back
    end
    right.push_front(left.pop_front)
    left.push_back(right.pop_back)
    puts (left.size + right.size) if rand(1000) == 0
  end

  [left.pop_front, right.pop_front].compact[0]
end

assert_equal(2, winner_part2(5))
puts "Part 2: #{winner_part2(input)}"
