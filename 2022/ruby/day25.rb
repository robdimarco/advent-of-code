def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

EXAMPLES = <<~TEXT.lines.map{|l| a, b = l.strip.split(/\s+/); [a.to_i, b]}
0              0
1              1
2              2
3             1=
4             1-
5             10
6             11
7             12
8             2=
9             2-
10             20
15            1=0
20            1-0
2022         1=11-2
12345        1-0---0
314159265  1121-1110-1=0
TEXT
CHAR_MAP = {
  '1' => 1,
  '2' => 2,
  '0' => 0,
  '-' => -1,
  '=' => -2,
}

def snafu_to_d(str)
  idx = 0
  str.chars.reverse.sum do |c|
    v = CHAR_MAP[c]
    rv = (5 ** idx) * v
    idx += 1
    rv
  end
end

EXAMPLES.each do |(exp, val)|
  assert_equal(exp, snafu_to_d(val), "Exp: #{exp}, Val: #{val}")
end

def d_to_snafu(d)
  return "0" if d == 0
  rv = ""
  while d > 0
    r = d % 5
    d = d / 5
    case r
    when 0, 1, 2
      rv = r.to_s + rv
    when 3
      rv = "=" + rv
      d += 1
    when 4
      rv = "-" + rv
      d += 1
    end
  end
  rv
end
EXAMPLES.each do |(val, exp)|
  assert_equal(exp, d_to_snafu(val), "Exp: #{exp}, Val: #{val}")
end
SAMPLE = <<TEXT
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
TEXT
def sum(input)
  input.lines.sum do |l|
    snafu_to_d(l.strip)
  end
end
def part1(input)
  d_to_snafu(sum(input))
end
assert_equal(4890, sum(SAMPLE))
assert_equal("2=-1=0", part1(SAMPLE))

puts "Part 1: #{part1(DATA)}"