def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

def generator(seed)
  a = seed
  b = seed.chars.reverse.map {|c| c == '1' ? '0' : '1'}.join
  [a, b].join('0')
end
assert_equal("100", generator("1"))
assert_equal("001", generator("0"))
assert_equal("11111000000", generator("11111"))
assert_equal("1111000010100101011110000", generator("111100001010"))

def collapse(str)
  return str if str.size.odd?
  (0...(str.size / 2)).map do |n|
    idx = 2 * n
    if str[idx] == str[idx + 1]
      '1'
    else
      '0'
    end
  end.join
end
assert_equal('110101', collapse('110010110100'))
assert_equal('100', collapse('110101'))

def checksum(str)
  loop do 
    return str if str.size.odd?
    str = collapse(str)
  end
end

assert_equal("100", checksum("110010110100"))

def fill(length, seed)
  while seed.size < length
    seed = generator(seed)
  end
  seed[0...length]
end
assert_equal("10000011110010000111", fill(20, "10000"))
def fill_cksum(length, seed)
  checksum(fill(length, seed))
end
assert_equal("01100", fill_cksum(20, "10000"))
puts "Part 1: #{fill_cksum(272, "01000100010010111")}"
puts "Part 2: #{fill_cksum(35651584, "01000100010010111")}"

