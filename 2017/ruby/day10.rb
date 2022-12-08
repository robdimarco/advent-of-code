def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
SAMPLE = "3,4,1,5"
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

def run(nums, data)
  lengths = data.split(',').map(&:to_i)
  knot(nums, lengths)[0..1].reduce(:*)
end

def knot(nums, lengths, iters=1)
  skip_size = 0
  pos = 0
  ar = nums.dup
  iters.times do 
    lengths.each do |length|
      # puts "length #{length}"
  #     Reverse the order of that length of elements in the list, starting with the element at the current position.
      rv = []
      require 'debug'
      # binding.break if pos == 3
      (0...length).each do |n|
        # pos -> pos + length - 1
        # pos + 1 -> pos + length - 2
        old_pos = (pos + n) % ar.size
        new_pos = (pos + length - n - 1) % ar.size
        rv[new_pos] = ar[old_pos]
        # puts "1. #{ar[old_pos]} from #{old_pos} to #{new_pos}"
      end
      (pos + length ... pos + ar.size).each do |n|
        n = n % ar.size
        rv[n] = ar[n]
        # puts "2. #{ar[n]} from #{n} to #{n}"
      end
      ar = rv
      # puts "#{ar.join(', ')}"
      pos += length + skip_size
      skip_size += 1
      # puts (['*'] * 80).join
    end
  end
  ar
end

assert_equal(12, run((0..4).to_a, SAMPLE))
puts "Part 1 #{run((0..255).to_a, DATA)}"

def full_hash(nums, data)
  lengths = data.chars.map(&:ord) + [17, 31, 73, 47, 23]
  sparse_hash = knot(nums, lengths, 64)
  dense_hash = (0...16).map do |n|
    idx = n * 16
    (1...16).to_a.reduce(sparse_hash[idx]) {|acc, v| acc ^ sparse_hash[idx+ v]}
  end
  dense_hash.map do |n|
    s = n.to_s(16)
    s = "0#{s}" if s.length == 1
    s
  end.join
end

assert_equal('a2582a3a0e66e6e86e3812dcb672a272', full_hash((0..255).to_a, ""))
assert_equal('33efeb34ea91902bb2f59c9920caa6cd', full_hash((0..255).to_a, "AoC 2017"))
assert_equal('3efbe78a8d82f29979031a4aa0b16a9d', full_hash((0..255).to_a, "1,2,3"))
assert_equal('63960835bcdc130f0b66d7ff4f6a5a8e', full_hash((0..255).to_a, "1,2,4"))
puts "Part 2 #{full_hash((0..255).to_a, DATA)}"
