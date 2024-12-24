TEST_DATA = <<~DATA
x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(data)
  values = {}
  operations = []
  data.lines.each do |line|
    if line.include?(":")
      key, value = line.split(":")
      values[key.strip] = value.strip.to_i
    elsif line.include?('->')
      left, target = line.split("->").map(&:strip)
      a, op, b = left.split(" ")
      operations << { a: a, b: b, op: op, target: target }
    end
  end
  [values, operations]
end
def execute(values, operation)
  a = operation[:a]
  b = operation[:b]
  op = operation[:op]
  target = operation[:target]
  return false if values[a].nil? || values[b].nil?

  case op
  when "AND"
    values[target] =values[a] & values[b]
  when "OR"
    values[target] = values[a] | values[b]
  when "XOR"
    values[target] =values[a] ^ values[b]
  else
    raise "Unknown operation #{op}"
  end
  true
end

def run(values, operations)
  while operations.any? do
    o = operations.shift
    unless execute(values, o)
      operations.push(o)
    end
  end
  values.keys.select {|k| k.start_with?("z")}.sort.reverse.map {|k| values[k]}.join.to_i(2)
end

def part1(data)
  values, operations = parse(data)
  run(values, operations)
end

def diffs(result, expected)
  problem_keys = []
  (0...result.size).each do |i|
    if result[i] != expected[i]
      n = result.size - i  - 1
      problem_keys.push("z#{n < 10 ? 0 : ""}#{n}")
    end
  end
  problem_keys
end

def part2(data)
  orig_values, orig_operations = parse(data)
  xs = orig_values.keys.select {|k| k.start_with?("x")}.sort.reverse.map{|k| orig_values[k]}.join
  ys = orig_values.keys.select {|k| k.start_with?("y")}.sort.reverse.map{|k| orig_values[k]}.join
  x = xs.to_i(2)
  y = ys.to_i(2)
  expected = (x+y).to_s(2)
  result = run(orig_values.dup, orig_operations.dup).to_s(2)
  puts "Expected:  #{expected}"
  puts "Result:   #{result}"
  data2 = data
  data2 = data.sub("y08 AND x08 -> z08", "y08 AND x08 -> cdj")
  data2 = data2.sub("dnc XOR rtp -> cdj", "dnc XOR rtp -> z08")
  data2 = data2.sub("btj AND tmm -> z16", "btj AND tmm -> mrb")
  data2 = data2.sub("btj XOR tmm -> mrb", "btj XOR tmm -> z16")
  data2 = data2.sub("jbc OR mnv -> z32", "jbc OR mnv -> gfm")
  data2 = data2.sub("kcv XOR pqv -> gfm", "kcv XOR pqv -> z32")
  data2 = data2.sub("x38 AND y38 -> qjd", "x38 AND y38 -> dhm")
  data2 = data2.sub("x38 XOR y38 -> dhm", "x38 XOR y38 -> qjd")

  # Used this to plot to GraphViz and look for oddities where the numbers diverged
  values, operations = parse(data2)
  operations.each do |o|
    puts "#{o[:a]} -> #{o[:target]} [label=\" #{o[:op]}\"]"
    puts "#{o[:b]} -> #{o[:target]} [label=\" #{o[:op]}\"]"
  end
  result = run(values.dup, operations).to_s(2)
  puts "Expected2: #{expected}"
  puts "Result2:   #{result}"
end
puts part2(REAL_DATA)

# 4     3         2         1         0
# 5432109876543210987654321098765432109876543210
# 1100011101111101101111100100101110001011001110
# 1100100001111101101111100100101110001011001110

# 
#
# ...

# y08 AND x08 -> z08  swap with dnc XOR rtp -> cdj 

# btj AND tmm -> z16  swap with btj XOR tmm -> mrb
# jbc OR mnv -> z32 swap with kcv XOR pqv -> gfm
# jdh OR qrw -> z45
