def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day4.txt')

def valid?(str)
  tokens = str.split(' ')
  tokens.size == tokens.uniq.size
end
assert_equal(true, valid?('aa bb cc dd ee'))
assert_equal(false, valid?('aa bb cc dd aa'))
assert_equal(true, valid?('aa bb cc dd aaa'))

puts "Part 1# #{DATA.lines.count {|l| valid?(l.strip)}}"
