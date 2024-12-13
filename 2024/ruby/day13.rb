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

def steps(a, b, prize, pos, path)
  rv = []
  bn = b + pos

  if bn.real <= prize.real && bn.imag <= prize.imag
    rv.push([bn, path + [:b]])
  end

  if path[-1] != :b
    an = a + pos

    if an.real <= prize.real && an.imag <= prize.imag
      rv.push([an, path + [:a]])
    end
  end
  rv
end

def path(a, b, prize)
  to_check = [[0 + 0i, []]]
  vals = []
  loop do 
    break if to_check.empty?
    pos, path = to_check.shift
    # puts "a->#{ path.select{|n|n ==:a}.size} b->#{ path.select{|n|n ==:a}.size}  Looking for #{prize}, at #{pos}"
    if pos == prize
      vals.push(cost(path))
    elsif path.select{|n|n ==:a}.size > 100 || path.select{|n|n ==:b}.size > 100
      next
    else
      to_check += steps(a, b, prize, pos, path)
    end
  end
  vals.min.to_i
end

def part1(data)
  data = parse(data)
  # data = data[0...1]
  data.map {|(a,b,prize)| path(a, b, prize)}.sum
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)