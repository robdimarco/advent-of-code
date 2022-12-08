def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
SAMPLE = "3,4,1,5"
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

def run(nums, data)
  lengths = data.split(',').map(&:to_i)
  skip_size = 0
  pos = 0
  ar = nums.dup
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
  ar[0..1].reduce(:*)
end

assert_equal(12, run((0..4).to_a, SAMPLE))
puts "Part 1 #{run((0..255).to_a, DATA)}"