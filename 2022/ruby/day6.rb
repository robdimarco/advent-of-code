def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day6.txt')

def first_marker(str, len = 4)
  ((len-1)...str.size).each do |n|
    return n + 1 if str[(n-len + 1)..n].chars.uniq.size == len
  end
  -2
end

[
  ['bvwbjplbgvbhsrlpgdmjqwftvncz', 5],
  ['nppdvjthqldpwncqszvftbrmjlhg', 6],
  ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 10],
  ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 11]
].each do |(val, exp)|
  assert_equal(exp, first_marker(val), val)
end
puts "Part 1 #{first_marker(DATA)}"
puts "Part 2 #{first_marker(DATA, 14)}"

