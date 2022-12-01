def assert_equal(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def sa(s)
  l, w, h = s.split('x').map(&:to_i)
  sides = [l*w, w*h, h*l]
  
  2*sides.sum + sides.min
end

def ribbon(s)
  l, w, h = s.split('x').map(&:to_i)
  min_x, min_y, _ = [l,w,h].sort
  2*min_x + 2* min_y + l*w*h
end

data = File.read('day2.txt').lines.map(&:strip)
puts "Part 1"
assert_equal(58, sa('2x3x4'))
assert_equal(43, sa('1x1x10'))

puts data.map {|l| sa(l)}.sum

puts "Part 2"
assert_equal(34, ribbon('2x3x4'))
assert_equal(14, ribbon('1x1x10'))

puts data.map {|l| ribbon(l)}.sum
