def assert_equal(expected, actual, str="")
raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt'))
  
SAMPLE = <<~TEXT
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
TEXT

def parse_instructions(input)
  input.lines.map do |l|
    reg, cmd, amt, _, val1, cmp, val2 = l.split(' ')
    {register: reg, cmd: cmd, amt: amt, val1: val1, cmp: cmp, val2: val2}
  end
end

def v(val, registers)
  if val =~ /\d+/
    val.to_i
  else
    registers[val]
  end
end

def registers(input)
  instructions = parse_instructions(input)
  i = 0
  registers = Hash.new(0)
  max_val = nil
  while i < instructions.size
    inst = instructions[i]
    if v(inst[:val1], registers).send(inst[:cmp], v(inst[:val2], registers))
      inc = v(inst[:amt], registers)
      inc *= -1 if inst[:cmd] == 'dec'
      new_val = registers[inst[:register]] + inc
      if max_val.nil? || max_val < new_val
        max_val = new_val
      end
      registers[inst[:register]] = new_val
    end
    i += 1
  end
  [registers, max_val]
end

def largest_value(input)
  r, _ = registers(input)
  r.values.max
end

def largest_value_ever(input)
  registers(input)[1]
end

assert_equal(1, largest_value(SAMPLE))
puts "Part 1: #{largest_value(DATA)}"
assert_equal(10, largest_value_ever(SAMPLE))
puts "Part 2: #{largest_value_ever(DATA)}"

# assert_equal(60, run_2(SAMPLE))
# puts "Part 2: #{run_2(DATA)}"