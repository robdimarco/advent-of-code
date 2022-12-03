def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day9.txt')

def decompress(inp)
  acc = ''
  idx = 0
  while idx < inp.size
    c = inp[idx]
    if c == '('
      close = inp.index(')', idx)
      a, b = inp[idx+1...close].split('x').map(&:to_i)
      # puts [a,b].inspect
      b.times do 
        # puts "Adding #{inp[close + 1...close + 1 + a]} from #{close + 1 } to #{close + 1 + a}"
        acc << inp[close + 1...close + 1 + a]
      end
      idx = close + a
    else
      acc << c
    end
    idx += 1
  end
  acc
end

[
  ['ADVENT', 'ADVENT'],
  ['ABBBBBC', 'A(1x5)BC'],
  ['XYZXYZXYZ', '(3x3)XYZ'],
  ['ABCBCDEFEFG', 'A(2x2)BCD(2x2)EFG'],
  ['(1x3)A', '(6x1)(1x3)A'],
  ['X(3x3)ABC(3x3)ABCY', 'X(8x2)(3x3)ABCY'],
].each do |exp, inp|
  assert_equal(exp, decompress(inp), inp)
end
puts "Part 1 #{data.lines.map {|l| decompress(l.strip).size}.sum}"

def decompress2(inp)
  acc = 0
  idx = 0
  while idx < inp.size
    c = inp[idx]
    if c == '('
      close = inp.index(')', idx)
      a, b = inp[idx+1...close].split('x').map(&:to_i)
      substr = inp[close + 1...close + 1 + a]
      acc += b * decompress2(substr)
      idx = close + a
    else
      acc += 1
    end
    idx += 1
  end
  acc
end

[
  [9, '(3x3)XYZ'],
  [20,'X(8x2)(3x3)ABCY'],
  [241920, '(27x12)(20x12)(13x14)(7x10)(1x12)A'],
  [445, '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'],
].each do |exp, inp|
  assert_equal(exp, decompress2(inp), inp)
end
puts "Part 2 #{decompress2(data.strip)}"

