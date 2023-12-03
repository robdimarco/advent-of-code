def val(arg, registers)
  registers.key?(arg) ? registers[arg] : arg.to_i
end

def part1(instructions)
  pos = 0
  registers = Hash.new(0)
  sound = 0

  while pos < instructions.size do
    args = instructions[pos].split(' ')
    cmd = args.shift
    pos += 1
    # puts "#{cmd}: #{args} #{registers}"
    case cmd
    when 'snd'
      sound = val(args[0], registers)
    when 'set'
      registers[args[0]] = val(args[1], registers)
    when 'add'
      registers[args[0]] = val(args[0], registers) + val(args[1], registers)
    when 'mul'
      registers[args[0]] = val(args[0], registers) * val(args[1], registers)
    when 'mod'
      registers[args[0]] = val(args[0], registers) % val(args[1], registers)
    when 'rcv'
      if val(args[0], registers) != 0
        puts "Received #{sound}"
        pos = instructions.size
      end
    when 'jgz'
      pos = pos - 1 + val(args[1], registers) if val(args[0], registers) > 0
    end
  end
  return sound
end

sample = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""

part1(sample.lines.map(&:strip))
part1(File.read('day18.txt').lines.map(&:strip))



def part2(instructions)
  pos_a = [0, 0]
  registers_a = [Hash.new(0), Hash.new(0)]
  registers_a[0]["p"] = 0
  registers_a[1]["p"] = 1
  queue_a = [[], []]
  blocked_a = [false, false]

  b_sent = 0
  running = 0

  while blocked_a != [true, true] || queue_a.flatten.any?  do
    pos = pos_a[running]
    registers = registers_a[running]

    args = instructions[pos].split(' ')
    cmd = args.shift
    pos_a[running] += 1
    # puts "#{cmd}: #{args} #{registers}"
    case cmd
    when 'set'
      registers[args[0]] = val(args[1], registers)
    when 'add'
      registers[args[0]] = val(args[0], registers) + val(args[1], registers)
    when 'mul'
      registers[args[0]] = val(args[0], registers) * val(args[1], registers)
    when 'mod'
      registers[args[0]] = val(args[0], registers) % val(args[1], registers)
    when 'jgz'
      pos_a[running] = pos_a[running] - 1 + val(args[1], registers) if val(args[0], registers) > 0
    when 'snd'
      n = (running + 1) % 2
      queue_a[n].push(val(args[0], registers))
      # puts "Added to #{n} queue #{queue_a[n]}"
      b_sent += 1 if running == 1
          
    when 'rcv'
      v = queue_a[running].shift
      if v.nil?
        pos_a[running] -= 1
        blocked_a[running] = true
        running = (running + 1) % 2
      else
        # puts "Received from #{running} queue #{queue_a[running]}"
        blocked_a[running] = false
        registers[args[0]] = v
      end
    end
  end
  return b_sent
end
sample = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""


puts part2(sample.lines.map(&:strip))
puts part2(File.read('day18.txt').lines.map(&:strip))
