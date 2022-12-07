def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day4.txt')

def valid_unique?(str)
  tokens = str.split(' ')
  tokens.size == tokens.uniq.size
end
assert_equal(true, valid_unique?('aa bb cc dd ee'))
assert_equal(false, valid_unique?('aa bb cc dd aa'))
assert_equal(true, valid_unique?('aa bb cc dd aaa'))

puts "Part 1# #{DATA.lines.count {|l| valid_unique?(l.strip)}}"

def valid?(str)
  tokens = str.split(' ').map {|s| s.chars.sort}
  tokens.size == tokens.uniq.size
end
assert_equal(true, valid?('abcde fghij'))
assert_equal(false, valid?('abcde xyz ecdab'))

puts "Part 1# #{DATA.lines.count {|l| valid?(l.strip)}}"