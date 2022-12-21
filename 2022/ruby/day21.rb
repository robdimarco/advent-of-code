def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

SAMPLE = <<~TEXT
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
TEXT

def part1(input)
  commands = input.lines.map {|s| s.strip.split(': ')}
  heap = {}
  while commands.any? do
    commands.reject {|(m,_)| heap[m]}.each do |(m, op)|
      vals = op.split(' ')
      if vals.size == 1 
        heap[m] = vals[0].to_i
        next
      end
      a, b, c = vals
      if heap[a] && heap[c]
        heap[m] = heap[a].send(b, heap[c])
        return heap[m] if m == 'root'
      end
    end
  end
end

def part2(input)
  commands = input.lines.map {|s| s.strip.split(': ')}
  humn = 0
  val, target, heap = solve_for_value(commands, 'root', {})
  loop do
    val, target, heap = solve_for_value(commands, target, heap.merge({target => val}))
    return val if target == 'humn'
  end
end

def solve_for_value(commands, target, heap)
  # puts "Looking for #{target} from #{heap}"
  loop do
    commands.reject {|(m,_)| heap[m] && m != target}.each do |(m, op)|
      vals = op.split(' ')
      if vals.size == 1 
        heap[m] = vals[0].to_i unless m == 'humn'
        next
      end
      # binding.break if m == target
      a, b, c = vals
      if m == target && (heap[a] || heap[c])
        if m == 'root'
          return heap[a] ? [heap[a], c, heap] : [heap[c], a, heap]
        else
          op = case b
          when '+'
            :-
          when '-'
            :+
          when '*'
            :/
          when '/'
            :*
          else 
            raise "Missing #{b}"
          end
          if heap[a]
            if b == '/' || b == '-'
              return [heap[a].send(b, heap[m]), c, heap]
            else
              return [heap[m].send(op, heap[a]), c, heap]
            end
          else
            return [heap[m].send(op, heap[c]), a, heap]
          end
        end
      end

      if heap[a] && heap[c]
        heap[m] = heap[a].send(b, heap[c])
      end
    end
  end
end

puts "Part 1: #{part1(DATA)}"
val = part2(DATA)
puts "Part 2: #{val}"

