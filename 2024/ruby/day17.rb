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
  # puts state.inspect
  # puts program.inspect
  output, state = run(state, program)
  # puts state.inspect
  output.join(",")
end
# If register C contains 9, the program 2,6 would set register B to 1.
# output = []
# state = {c:9}
# run(state, [2,6])
# puts [output, state].inspect
# output = []; state = {a: 10}
# puts run(state, [5,0,5,1,5,4]).inspect
# puts run({a: 2024}, [0,1,5,4,3,0]).inspect
# puts run({b: 29}, [1,7]).inspect
# puts run({b: 2024, c: 43690}, [4,0]).inspect
# If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
# If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
# If register B contains 29, the program 1,7 would set register B to 26.
# If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
puts part1(TEST_DATA)
puts part1(REAL_DATA)