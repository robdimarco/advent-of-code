TEST_DATA = <<~DATA
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

def combo(state, operand)
  # Combo operands 0 through 3 represent literal values 0 through 3.
  # Combo operand 4 represents the value of register A.
  # Combo operand 5 represents the value of register B.
  # Combo operand 6 represents the value of register C.
  # Combo operand 7 is reserved and will not appear in valid programs.
  case operand
  when 0,1,2,3
    operand
  when 4
    state[:a]
  when 5
    state[:b]
  when 6
    state[:c]
  end
end

def instruction(state, inst, operand, output, num)
  rv = num + 2
  case inst
  when 0
    state[:a] = (state[:a] / (2**combo(state, operand))).to_i
  when 1
    state[:b] = state[:b] ^ operand
  when 2
    state[:b] = combo(state, operand) % 8
  when 3
    rv = operand if state[:a] != 0
  when 4
    state[:b] = state[:b] ^ state[:c]
  when 5
    # puts "fire #{operand} #{combo(state, operand) % 8}"
    output.push(combo(state, operand) % 8)
  when 6
    state[:b] = (state[:a] / (2**combo(state, operand))).to_i
  when 7
    state[:c] = (state[:a] / (2**combo(state, operand))).to_i
  end
  rv
end

def run(state, program)
  output = []
  num = 0
  while num < program.length
    num = instruction(state, program[num], program[num+1], output, num)
    # puts "#{num} #{state.inspect} #{output.inspect}"
  end
  [output, state]
end

def parse(data)
  hsh = {}
  program = nil
  data.each_line do |line|
    if line =~ /Register (\w): (\d+)/
      hsh[$1.downcase.to_sym] = $2.to_i
    elsif line =~ /Program: (.+)/
      program = $1.split(",").map(&:to_i)
    end
  end
  [hsh, program]
end

def part1(data)
  state, program = parse(data)
  output, state = run(state, program)

  output.join(",")
end



def part2(data)
  state, program = parse(data)
  run(state.merge(a: (117440 )), program).inspect
  to_check = (0...8).map { |n| [n] }
  possibles = []
  puts "Trying to match #{program}"
  while to_check.any? do
    vals = to_check.shift
    val = 0
    vals.each_with_index do |v, idx|
      val += v << (3 * idx)
    end

    nstate = state.merge({:a => val})
    # puts "Checking #{val} from #{nstate.inspect}"
    o, _ = run(nstate, program)
    # puts "Checking #{val} => #{o.inspect} from #{nstate.inspect}"
    if o == program
      # puts "Possible: #{val}"
      possibles.push(val)
    elsif o.last(vals.size) == program.last(vals.size)
      # puts "Matched #{val} #{o.inspect} #{vals.size}"
      (0...8).each do |nn|
        to_check.push([nn] + vals)
      end
    end
  end
  [possibles.min, possibles.size].inspect
end

TEST_DATA_2 = <<~DATA
Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
DATA
puts part2(TEST_DATA_2)
puts part2(REAL_DATA)
