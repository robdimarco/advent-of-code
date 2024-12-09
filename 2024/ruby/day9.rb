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
  end
  sum
end

def part2(data)
  cnts = {}
  h = {}
  gaps = Hash.new {|h,k| h[k] = []}
  idx = 0

  data.scan(/..?/).each_with_index do |s, id|
    a, b = s.chars.map(&:to_i)
    (0...a).each do |n|
      h[idx+n] = id
    end
    cnts[id] = [idx, a]
    gaps[b.to_i].push idx + a
    idx += a + b.to_i
  end

  cnts.keys.sort.reverse.each do |id|
    curr, l = cnts[id]
    g_key = gaps.keys.select {|n| n >= l && gaps[n].any? && gaps[n].min < curr}.sort_by {|g| gaps[g].min}.first
    if g_key
      g = gaps[g_key].min
      (0...l).each do |n|
        h[g + n] = id
        h[curr + n] = nil
      end
      gaps[g_key] -= [g]
      gaps[g_key - l] += [g + l]
    end
  end

  sum = 0
  h.keys.sort.each do |k|
    v = h[k]
    sum += k * v.to_i
  end
  sum
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
