def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

SAMPLE = "0 2 7 0"

def process(input)
  blocks = input.split(/\s+/).map(&:to_i)
  prev = {blocks => 0}
  steps = 0
  loop do
    steps += 1
    max = blocks.each_with_index.max_by {|(b,i)| [b, -i]}[1]    
    blocks = blocks.dup
    val = blocks[max]
    blocks[max] = 0
    val.times do |inc|
      idx = (max + inc + 1) % blocks.size
      blocks[idx] += 1
    end
    # puts "Moving #{val} from #{max} #{blocks.inspect}"
    prev_steps = prev[blocks]
    if prev_steps
      return [steps, steps-prev_steps]
    end
    prev[blocks] = steps
    # break if steps > 5
  end
end

def steps(input)
  process(input)[0]
end

def size(input)
  process(input)[1]
end
assert_equal(5, steps(SAMPLE))
puts "Part 1: #{steps(DATA)}"

assert_equal(4, size(SAMPLE))
puts "Part 2: #{size(DATA)}"
