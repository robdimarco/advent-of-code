def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
TEXT

def parse(data)
  lines = data.lines.map(&:strip)
  rv = []
  current_monkey = nil
  lines.each do |line|
    match = /Monkey (\d+)/.match(line)
    if match
      current_monkey = {id: match[1].to_i, inspected: 0}
      rv << current_monkey
    end
    match = /Starting items: (.*)/.match(line)
    if match
      current_monkey[:items] = match[1].split(', ').map(&:to_i)
    end      
    match = /Operation: new = (.*)/.match(line)
    if match
      current_monkey[:operation] = match[1].split(' ')
    end      
    match = /Test: divisible by (.*)/.match(line)
    if match
      current_monkey[:divisible_by] = match[1].to_i
    end      
    match = /If (true|false): throw to monkey (.*)/.match(line)
    if match
      current_monkey[match[1].to_sym] = match[2].to_i
    end     
  end
  rv
end

def apply_operation(operation, item)
  a, b, c = operation
  a = a == 'old' ? item : a.to_i
  c = c == 'old' ? item : c.to_i
  # puts "Applying #{a} #{b} #{c}"
  a.send(b.to_sym, c)
end
assert_equal(16, apply_operation(%w(old * old), 4))
assert_equal(6, apply_operation(%w(old + 2), 4))

def run(data, turns: 20, divide: true)
  monkeys = parse(data)
  monkey_by_id = monkeys.each_with_object({}) do |m, h|
    h[m[:id]] = m
  end

  divisor = monkeys.map {|m| m[:divisible_by]}.reduce(1, &:*)

  turns.times do |n|
    monkeys.each do |monkey|
      monkey[:items].each do |item|
        monkey[:inspected] += 1
        item = apply_operation(monkey[:operation], item)
        item = item / 3 if divide
        item = item % divisor
        if item % monkey[:divisible_by] == 0
          monkey_by_id[monkey[:true]][:items].push(item)
        else
          monkey_by_id[monkey[:false]][:items].push(item)
        end
      end
      monkey[:items] = []
    end
    # print '.' if n % 100 == 0
  end
  # puts monkeys
  m1, m2 = monkeys.sort_by {|m| m[:inspected]}[-2..-1]
  m1[:inspected] * m2[:inspected]
end

# puts parse(SAMPLE)
assert_equal(20, run(SAMPLE, turns: 1))
assert_equal(10605, run(SAMPLE))
puts "Part 1 #{run(DATA)}"

assert_equal(24, run(SAMPLE, turns: 1, divide: false))
assert_equal(103 * 99, run(SAMPLE, turns: 20, divide: false))
assert_equal(5204 * 5192, run(SAMPLE, turns: 1000, divide: false))
assert_equal(2713310158, run(SAMPLE, turns: 10_000, divide: false))
# assert_equal(2713310158, run(SAMPLE, turns: 10_000, divide: false))
puts "Part 2 #{run(DATA, turns: 10_000, divide: false)}"
