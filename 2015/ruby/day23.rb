def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day23.txt')

def execute(instructions, position, registers)
  i = instructions[position]
  cmd = i[0]
  case cmd
  when 'hlf'
    registers[i[1]] /= 2
  when 'tpl'
    registers[i[1]] *= 3
  when 'inc'
    registers[i[1]] += 1
  when 'jmp'
    position += i[1].to_i
    puts "#{cmd} at #{position} with #{registers}"
    return [instructions, position, registers]
  when 'jie'
    if registers[i[1]] % 2 == 0
      position += i[2].to_i
      puts "#{cmd} at #{position} with #{registers}"
      return [instructions, position, registers]
    end    
  when 'jio'
    if registers[i[1]] == 1
      position += i[2].to_i
      puts "#{cmd} at #{position} with #{registers}"
      return [instructions, position, registers]
    end
  else
    raise "Unknown cmd #{cmd}"
  end
  puts "#{cmd} at #{position} with #{registers}"
  position += 1

  [instructions, position, registers]
end

def parse(data)
  data.lines.map do |line| 
    line.strip.split(/,?\s+/)
  end
end

def run(data, registers= Hash.new(0))
  instructions = parse(data)
  position = 0

  while position < instructions.size do
    instructions, position, registers = execute(instructions, position, registers)
  end

  registers
end

sample=<<~TEXT
inc a
jio a, +2
tpl a
inc a
TEXT

# assert_equal(2, run(sample)['a'])
puts "Part 1: #{run(data)}"
r2 = Hash.new(0)
r2['a'] = 1
puts "Part 2: #{run(data, r2)}"