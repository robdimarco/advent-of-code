TEST_DATA = <<~DATA
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(lines)
  rv = []
  lines = lines.lines
  loop do 
    break if lines[0].nil?
    a = (0..2).to_a.map do
      n = lines.shift
      Complex(*n.scan(/\d+/).map(&:to_i))
    end
    rv.push(a)
    lines.shift
  end
  rv
end

def cost(path)
  path.sum{|n| n == :a ? 3 : 1}
end

def solver(a, b, c, d, e, f)
  a, b, c, d, e, f = [a, b, c, d, e, f].map(&:to_f)
  x = ((c/a - (b*f/a/e)) / (1 - b*d/a/e))
  y = f/e - (d*x/e)
  return [x, y]
end

def path(a, b, prize)
  x, y = solver(a.real, b.real, prize.real, a.imag, b.imag, prize.imag).map(&:round)
  x * a + y * b == prize ? (x * 3 + y) : 0
end

def part1(data)
  data = parse(data)
  data.map {|(a,b,prize)| path(a, b, prize)}.sum
end

def part2(data)
  data = parse(data)
  data.each {|r| r[2] += 10000000000000 + 10000000000000i}
  data.map {|(a,b,prize)| path(a, b, prize)}.sum
end

# puts solver(94.0, 22.0, 8400.0, 34.0, 67.0, 5400.0).inspect
# puts solver(94.0, 22.0, 10000000008400.0, 34.0, 67.0, 10000000005400.0).inspect
# puts solver(26.0, 67.0, 10000000012748.0, 66.0, 21.0, 10000000012176.0).inspect
puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
