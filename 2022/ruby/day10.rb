def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
TEXT

def signals_at_time(data)
  instructions = data.lines.map do |l|
    l.strip.split(' ')
  end

  i = 0
  cycle = 1
  signals_at_time = {1 => 1}
  addx_wait = false
  signal = 1
  while i < instructions.size do
    cmd, n = instructions[i]
    case cmd
    when 'noop'
      i += 1
    when 'addx'
      if addx_wait
        addx_wait = false
        i += 1
        signal += n.to_i
      else
        addx_wait = true
      end
    end
    cycle += 1
    signals_at_time[cycle] = signal
  end
  signals_at_time
end

def sum_strengths_at_time(data, sample_times)
  sample_times.map {|n| signals_at_time(data)[n] * n}.sum
end

def print_screen(data)
  signals = signals_at_time(data)
  rv = signals.keys.sort.map do |n|
    signal = signals[n]
    loc = n % 40
    c = if [loc, loc-1, loc-2].include?(signal)
      '#'
    else
      '.'
    end
    puts "At cycle #{n} got signal #{signal} for #{c}"
    c += "\n" if n % 40 == 0
    c
  end
  rv.join
end

assert_equal(420, sum_strengths_at_time(SAMPLE, [20]))
assert_equal(13140, sum_strengths_at_time(SAMPLE, [20, 60, 100, 140, 180, 220]))
puts "Part 1 #{sum_strengths_at_time(DATA, [20, 60, 100, 140, 180, 220])}"

OUTPUT=<<~TEXT
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
..
TEXT

# assert_equal("\n" + OUTPUT.lines.join.strip, "\n" + print_screen(SAMPLE))
puts "Part 2 \n#{print_screen(DATA)}"