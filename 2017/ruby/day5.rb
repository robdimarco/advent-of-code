def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day5.txt')

SAMPLE = <<~TXT
0
3
0
1
-3
TXT

def steps(input, jump=nil)
  instructions = input.lines.map {|l| l.strip.to_i}
  i = 0
  steps = 0
  while i < instructions.size
    steps += 1
    v = instructions[i]
    if jump == :strange && v >= 3
      instructions[i] -= 1
    else
      instructions[i] += 1
    end
    i += v
    # puts "#{steps} #{i} - #{instructions.inspect}"
  end

  steps
end

assert_equal(5, steps(SAMPLE))
puts "Part 1 #{steps(DATA)}"

assert_equal(10, steps(SAMPLE, :strange))
puts "Part 2 #{steps(DATA, :strange)}"
