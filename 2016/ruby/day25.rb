def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day25.txt')
# SAMPLE = <<~TEXT
# cpy 2 a
# tgl a
# tgl a
# tgl a
# cpy 1 a
# dec a
# dec a
# TEXT

def parse_instructions(lines)
  lines.map do |line|
    next if line =~ /^\s*\#/
    tokens = line.split(' ')
  end.compact
end
def translate(a, registers)
  a =~ /\d+/ ? a.to_i : registers[a]
end

def process(data, registers, max_output)
  instructions = parse_instructions(data.lines.map(&:strip))
  pos = 0
  cnt = 0
  output = ""
  while pos < instructions.size do
    cnt += 1
    cmd, a, b, c= instructions[pos]
    # puts instructions[pos].inspect
    # require 'debug'; binding.break
    case cmd
    when 'cpy'
      registers[b] = translate(a, registers)
    when 'mul'
      registers[a] += (translate(b, registers)) * (translate(c, registers))
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
    when 'out'
      output += translate(a, registers).to_s
      break if output.size >= max_output || !(output =~ /^0(10)*1?$/)
    when 'tgl'
      # puts "toggle"
      val = translate(a, registers) + pos
      if val < instructions.size && val >= 0
        i = instructions[val]
        case i[0]
        when 'dec', 'tgl', 'out'
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
    # puts "#{pos} #{instructions[pos]} => #{registers}: #{instructions.inspect}" if rand(1_000_000) == 0
    pos += 1
  end
  [registers, output]
end

i = 0
longest = ''
longest_i = nil
loop do
  target = '0101010101010101010101010101010'
  i += 1
  _, output = process(DATA, {'a' => i}, target.size)
  if output == target
    puts "Got #{i}"
  end
  if output.size > longest.size
    longest = output
    longest_i = i
  end
  puts "output: #{output}, longest #{longest} from #{longest_i}" if i % 100 == 0
end