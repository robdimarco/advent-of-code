def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day20.txt')
SAMPLE = <<~TEXT
5-8
0-2
4-7
TEXT

def overlap?(r1, r2)
  # r1[1] < r2[0] && r1[0]
  r1[1] > r2[0] && r1[0] < r2[0] ||
    r1[0] < r2[1] && r1[0] > r2[0] || r1[1] + 1 == r2[0] || r2[1] + 1 == r1[0]
end

assert_equal(true, overlap?([5,8], [4,7]))
assert_equal(true, overlap?([4,7], [5,8]))
assert_equal(true, overlap?([4,7], [8,9]))
assert_equal(false, overlap?([5,7], [9,10]))
def merge_range(r1, r2)
  [[r1[0], r2[0]].min, [r1[1], r2[1]].max]
end
assert_equal([4,8], merge_range([5,8], [4,7]))
assert_equal([4,8], merge_range([4,7], [5,8]))
assert_equal([4,9], merge_range([4,7], [8,9]))

def compact_ranges(ranges)
  target = ranges.dup
  loop do
    merges = false
    target.each_with_index do |a, i|
      next if a.nil?
      (i...target.size).each do |j|
        b = target[j]
        next if b.nil?
        if overlap?(a, b)
          target[i] = a = merge_range(a,b)
          target[j] = nil
          merges = true
        end
      end
    end
    target = target.compact
    return target unless merges
  end
  target
end

assert_equal([[0,1], [5,10]], compact_ranges([[0,1], [5,9], [6,7], [8,10]]))

def lowest_allowed(data)
  ranges = data.lines.map {|l| l.scan(/\d+/).map(&:to_i)}.sort
  ranges = compact_ranges(ranges).sort
  i = 1
  while i < ranges.size
    _, prev_max = ranges[i-1]
    min,_ = ranges[i]
    return prev_max + 1 unless min - prev_max == 1
    i+= 1
  end

  ranges[-1][1] + 1
end

def total_allowed(data, target)
  ranges = data.lines.map {|l| l.scan(/\d+/).map(&:to_i)}.sort
  ranges = compact_ranges(ranges).sort
  
  total = 0
  i = 1
  while i < ranges.size
    _, prev_max = ranges[i-1]
    min,max = ranges[i]
    break if max > target
    total += min - prev_max - 1
    i += 1
  end

  total += target - ranges[-1][-1]
  total
end

assert_equal(3, lowest_allowed(SAMPLE))
puts "Part 1: #{lowest_allowed(DATA)}"

assert_equal(2, total_allowed(SAMPLE, 9))
puts "Part 2: #{total_allowed(DATA, 4294967295)}"