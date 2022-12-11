
def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
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

def knot_hash(data)
  nums = (0..255).to_a
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

def squares(key)
  (0..127).map do |n|
    knot_hash("#{key}-#{n}").chars.map {|c| c.to_i(16).to_s(2).rjust(4, '0')}.join
  end
end

def square_count(key)
  squares(key).map {|n| n.count('1')}.sum
end

# assert_equal(8108, square_count('flqrgnkx'))
# puts "Part 1: #{square_count('jxqlasbh')}"

def regions(key)
  sq = squares(key)
  puts "From key #{key} #{sq.size}"
  # puts sq[0].inspect
  # puts sq[1].inspect
  uncrawled = []
  to_crawl = []
  crawled = []
  region_count = 0
  uncrawled = (0...sq.size).each_with_object([]) do |x, ar|
    (0...sq.size).map do |y|
      ar.push([y, x])
    end
  end

  while to_crawl.any? || uncrawled.any?
    puts "TC: #{to_crawl.size} UC: #{uncrawled.size} RC #{region_count}" if rand(1000) == 0
    pos, region, old = to_crawl.shift || [uncrawled.shift, nil, nil]
    x, y = pos
    puts "Checking #{pos.inspect} with region #{region} from #{old.inspect} with value #{sq[y][x]}" if x < 8 && y < 8
    next if sq[y][x] == '0'

    region_count = region = region_count + 1 if region.nil?
    if x < 8 && y < 8
      puts "Found #{region} for x=#{x} and y = #{y}"
    end
    [
      [-1, 0], [0, -1], [0, 1], [1, 0]
    ].each do |(dx, dy)|
      new_pos = [x + dx, y+dy]
      if uncrawled.include?(new_pos)
        uncrawled.delete(new_pos)
        to_crawl.unshift([new_pos, region, pos])
      end
    end
  end

  region_count
end

assert_equal(1242, regions('flqrgnkx'))
puts "Part 2: #{regions('jxqlasbh')}"
