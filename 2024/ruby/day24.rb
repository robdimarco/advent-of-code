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

def part1(data)
  values, operations = parse(data)
  while operations.any? do
    o = operations.shift
    unless execute(values, o)
      operations.push(o)
    end
  end
  values.keys.select {|k| k.start_with?("z")}.sort.reverse.map {|k| values[k]}.join.to_i(2)
end


def part2(data)
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
