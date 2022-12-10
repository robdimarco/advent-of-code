def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
0: 3
1: 2
4: 4
6: 4
TEXT

def severity(data, start_pos = 0)
  scanners = data.lines.each_with_object({}) do |l, hsh| 
    a, b = l.strip.split(': ').map(&:to_i)
    hsh[a] = b
  end

  penalty = 0
  (0..scanners.keys.max).each do |n|
    pos = n + start_pos
    depth = scanners[n]
    next if depth.nil?

    penalty += pos * depth if pos % (2 * (depth - 1)) == 0
  end
  penalty
end
# n % 4 != 0 && (n+1) % 2 != 0 && (n+4) % 6 != 0 && (n+6) % 6 != 0

# n % 4 != 0
# n % 2 != 1
# n % 6 != 4
# n % 6 != 0

# 4, 2, 0, 0, 6, 0, 6

def fewest(data)
  i = 0
  scanners = data.lines.each_with_object({}) do |l, hsh| 
    a, b = l.strip.split(': ').map(&:to_i)
    hsh[a] = b
  end
  loop do
    pen = (0..scanners.keys.max).find do |n|
      pos = n + i
      depth = scanners[n]
      !depth.nil? && pos % (2 * (depth - 1)) == 0
    end

    return i if pen.nil?
    i += 1
    # break if i > 15
  end
end
# 1: 2
# 2: 0, 2, 4
# 3: 0, 4, 8
# 4: 0, 6, 12
# 5: 0, 8, 

assert_equal(24, severity(SAMPLE))
puts "Part 1 #{severity(DATA)}"
assert_equal(10, fewest(SAMPLE))
# assert_equal(10, fewest(SAMPLE.strip + "\n12: 3"))
puts "Part 2 #{fewest(DATA)}"
