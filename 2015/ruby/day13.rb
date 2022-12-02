def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day13.txt')

sample = <<~TXT
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
TXT

def parse_line(line)
  tokens = line.split(' ')
  a = tokens[0]
  b = tokens[-1].gsub('.', '')
  value = tokens[3].to_i * (tokens[2] == 'gain' ? 1 : -1)
  [a, b, value]
end
def combos(input)
  rv = Hash.new do |h,k|
    h[k] = Hash.new(0)
  end
  input.lines.map(&:strip).each do |line|
    a, b, value = parse_line(line)
    rv[a][b] = value
  end
  rv
end

def total_change(input, include_me=false)
  combos = combos(input)
  names = combos.keys
  names += ['***ME***'] if include_me
  names.permutation.map do |order|
    i = -1
    sum = 0
    while i < order.length - 1;
      v = combos[order[i]][order[i+1]] + combos[order[i+1]][order[i]]
      sum += v
      i += 1
    end
    sum
  end.max
end

assert_equal(['Alice', 'Bob', 54], parse_line('Alice would gain 54 happiness units by sitting next to Bob.'))
assert_equal(['Alice', 'Bob', -2], parse_line('Alice would lose 2 happiness units by sitting next to Bob.'))
assert_equal(330, total_change(sample))

puts "Part 1: #{total_change(data)}"
puts "Part 2: #{total_change(data, true)}"