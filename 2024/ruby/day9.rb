TEST_DATA ="2333133121414131402"
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt").lines.map(&:strip).join


def part1(data)
  h = {}
  idx = 0

  data.scan(/..?/).each_with_index do |s, id|
    a, b = s.chars.map(&:to_i)
    (0...a).each do |n|
      h[idx+n] = id
    end
    idx += a + b.to_i
  end

  keys = h.keys.sort.reverse
  idx = 0
  keys.each do |k|
    break if k < idx 
    v = h[k]
    loop do
      if h[idx].nil?
       h[idx]  = v
       h[k] = nil
      #  puts "Put #{v} into #{idx}"
       break       
      end
      break if k <= idx 
      idx += 1
    end
  end

  sum = 0
  h.keys.sort.each do |k|
    v = h[k]
    sum += k * v.to_i
    # puts "#{k} * #{v.to_i} => #{sum} "
  end
  sum
end

def part2(data)
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)
