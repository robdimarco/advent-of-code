def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

MAP = {
  ne: [1, 1],
  n: [0, 2],
  nw: [-1, 1],
  sw: [-1, -1],
  s:  [0, -2],
  se: [1, -1],
}

def steps_away(data, furthest=false)
  vals = data.split(',').map(&:to_sym)
  pos = [0, 0]
  furthest_step = 0
  vals.each do |steps|
    step = MAP[steps]
    # puts "#{steps} means stepping #{step.inspect} from #{pos.inspect} "
    pos = [pos[0] + step[0], pos[1] + step[1]]
    furthest_step = [pos.map(&:abs).sum / 2, furthest_step].max
  end
  furthest ? furthest_step : pos.map(&:abs).sum / 2
end

assert_equal(3, steps_away('ne,ne,ne'))
assert_equal(0, steps_away('ne,ne,sw,sw'))
assert_equal(2, steps_away('ne,ne,s,s'))
assert_equal(3, steps_away('se,sw,se,sw,sw'))

puts "Part 1: #{steps_away(DATA)}"
puts "Part 1: #{steps_away(DATA, true)}"