def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day7.txt')

def valid_tls?(str)
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

def valid_ssl?(str)
  supernet = []
  hypernet = []

  acc = ''
  str.chars.each do |c|
    if c == '['
      supernet << acc
      acc = ''
    elsif c == ']'
      hypernet << acc
      acc = ''
    else
      acc << c
    end
  end
  supernet << acc
  babs = []
  hypernet.each do |s|
    (0..s.size - 2).each do |idx|
      slice = s[idx..idx+2]
      babs << slice if slice[0] == slice[2] && slice[0] != slice[1]
    end
  end
  supernet.each do |s|
    babs.each do |bab|
      aba = [bab[1], bab[0], bab[1]].join
      return true if s.include?(aba)
    end
  end

  false
end

[
  [true, 'abba[mnop]qrst'],
  [false, 'abcd[bddb]xyyx'],
  [false, 'aaaa[qwer]tyui'],
  [true, 'ioxxoj[asdfgh]zxcvbn']
].each do |(exp, inp)|
  assert_equal(exp, valid_tls?(inp), inp)
end
puts "Part 1: #{data.lines.select {|l| valid_tls?(l.strip)}.size}"

[
  [true, 'aba[bab]xyz'],
  [false, 'xyx[xyx]xyx'],
  [true, 'aaa[kek]eke'],
  [true, 'zazbz[bzb]cdb']
].each do |(exp, inp)|
  assert_equal(exp, valid_ssl?(inp), inp)
end
puts "Part 2: #{data.lines.select {|l| valid_ssl?(l.strip)}.size}"

