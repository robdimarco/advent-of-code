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
puts "Part 1: #{winner(input)}"