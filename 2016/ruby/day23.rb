def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day23.txt')
SAMPLE = <<~TEXT
cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
TEXT

def parse_instructions(lines)
  lines.map do |line|
    tokens = line.split(' ')
  end
end
def translate(a, registers)
  a =~ /\d+/ ? a.to_i : registers[a]
end

def process(data, registers=Hash.new(0))
  instructions = parse_instructions(data.lines.map(&:strip))
  pos = 0
  cnt = 0
  while pos < instructions.size do
    cnt += 1
    cmd, a, b = instructions[pos]
    # puts instructions[pos].inspect
    # require 'debug'; binding.break
    case cmd
    when 'cpy'
      registers[b] = translate(a, registers)
    when 'inc'
      registers[a] += 1
    when 'dec'
      registers[a] -= 1
    when 'jnz'
      val = translate(a, registers)
      if val != 0
        pos += translate(b, registers) - 1
        # puts "Putting in jump to #{b} to #{pos}"
      end
    when 'tgl'
      # puts "toggle"
      val = translate(a, registers) + pos
      if val < instructions.size && val >= 0
        i = instructions[val]
        case i[0]
        when 'dec', 'tgl'
          instructions[val] = ['inc', i[1]]
        when 'inc'
          instructions[val] = ['dec', i[1]]
        when 'jnz'
          instructions[val] = ['cpy', i[1], i[2]]
        when 'cpy'
          instructions[val] = ['jnz', i[1], i[2]]
        else
          raise "Unknown instruction #{i.inspect}"
        end
      end
    else
    end
    # if cnt ==10000
    #   puts instructions.inspect
    #   break
    # end
    puts "#{pos} #{instructions[pos]} => #{registers}: #{instructions.inspect}" if rand(1_000_000) == 0
    pos += 1
  end
  registers
end

assert_equal(3, process(SAMPLE, {})['a'])
puts "Part 1 #{process(DATA, {'a' => 7})}"
puts "Part 2 #{process(DATA, {'a' => 12})}"