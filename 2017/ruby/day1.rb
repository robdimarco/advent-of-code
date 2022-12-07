def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day1.txt').strip

def sum(str)
  s = (1..(str.size - 1)).sum do |n|
    # puts str[n]
    str[n] == str[n-1] ? str[n].to_i : 0
  end
  s += str[0].to_i if str[0] == str[-1]
  s
end

assert_equal(3, sum('1122'))
assert_equal(4, sum('1111'))
assert_equal(0, sum('1234'))
assert_equal(9, sum('91212129'))

puts "Part 1: #{sum(DATA)}"

def sum2(str)
  half = str.size / 2
  (0...str.size).sum do |n|
    idx = (n+half) % str.size
    # ptus "#{str[n]} #{str[idx]} from #{n} -> #{idx}"
    str[n] == str[idx] ? str[n].to_i : 0
  end
end

assert_equal(6, sum2('1212'))
assert_equal(0, sum2('1221'))
assert_equal(4, sum2('123425'))
assert_equal(12,sum2( '123123'))
assert_equal(4, sum2('12131415'))
puts "Part 2: #{sum2(DATA)}"
