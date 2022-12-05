def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day15.txt')


SAMPLE = <<~TEXT
Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
TEXT

def parse(data)
  data.lines.map do |l|
    positions = /(\d+) positions/.match(l)[1].to_i
    position = /at position (\d+)/.match(l)[1].to_i
    [positions, position]
  end
end

def first_time(data)
  wheels = parse(data)
  start_time = 0

  loop do
    through = true
    i = 0
    while i < wheels.size && through 
      positions, position = wheels[i]
      through = (position + start_time + i + 1) % positions == 0
      i += 1
    end
    return start_time if through

    start_time += 1
  end
  start_time
end

assert_equal(5, first_time(SAMPLE))

puts "Part 1 #{first_time(DATA)}"