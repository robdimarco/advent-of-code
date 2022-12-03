def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day7.txt')

def valid?(str)
  checkable = true
  seq = ''
  chars = str.chars
  matched = false
  (0..chars.size - 4).each do |idx|
    if chars[idx] == '['
      checkable = false
    elsif chars[idx] == ']'
      checkable = true
    elsif chars[idx] == chars[idx + 3] && chars[idx + 1] == chars[idx + 2] && chars[idx] != chars[idx + 1]
      return checkable unless checkable
      matched = true
    end
  end
  matched
end

[
  [true, 'abba[mnop]qrst'],
  [false, 'abcd[bddb]xyyx'],
  [false, 'aaaa[qwer]tyui'],
  [true, 'ioxxoj[asdfgh]zxcvbn']
].each do |(exp, inp)|
  assert_equal(exp, valid?(inp), inp)
end
# puts data.lines.map {|l| [l, valid?(l.strip)].join(" ")}.join("\n")
puts "Part 1: #{data.lines.select {|l| valid?(l.strip)}.size}"