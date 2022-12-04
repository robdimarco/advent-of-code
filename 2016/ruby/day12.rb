def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day12.txt')

SAMPLE = <<~TXT
cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
TXT

def parse_instructions(lines)
  lines.map do |line|
    tokens = line.split(' ')
  end
end

def process(data, registers=Hash.new(0))
  instructions = parse_instructions(data.lines.map(&:strip))
  pos = 0
  cnt = 0
  while pos < instructions.size do
    cnt += 1
    cmd, a, b = instructions[pos]
    # require 'debug'; binding.break
    case cmd
    when 'cpy'
      registers[b] = a =~ /\d+/ ? a.to_i : registers[a]
    when 'inc'
      registers[a] += 1
    when 'dec'
      registers[a] -= 1
    when 'jnz'
      val = a =~ /\d+/ ? a.to_i : registers[a]
      if val != 0
        # puts "  Jumping #{b} spots as #{a} is #{val}"
        pos += b.to_i - 1
      else 
        # puts "  Not jumping #{b} spots as #{a} is #{val}"
      end
    end
    pos += 1
    # puts "pos #{pos}, #{registers.inspect}"
    # break if cnt > 15
  end
  registers
end

# assert_equal(42, process(SAMPLE)['a'])
puts "Part 1: #{process(data)}"
r = Hash.new(0)
r['c'] = 1
puts "Part 2: #{process(data, r)}"
