def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day7.txt')

def parse_line(line)
  tokens = line.split(/\s+/)
  if line.start_with?('NOT')
    [:not, tokens[-1], tokens[1]]
  elsif line =~ /AND|OR|LSHIFT|RSHIFT/
    [tokens[1].downcase.to_sym, tokens[-1], tokens[0], tokens[2]]
  else
    [:assign, tokens[-1], tokens[0]]
  end
end

def v(env, val)
  if val =~ /^\d+$/
    val.to_i
  else
    env[val]
  end
end

def assign(env, opts)
  target, value = opts
  env[target] ||= v(env, value)
end

def not(env, opts)
  target, value = opts
  orig = v(env, value)
  return false if orig.nil?

  rv = ~orig
  val = (0...16).map { |n| rv[n]}.reverse.join.to_i(2)
  # puts "not of #{orig} = #{val}"
  env[target] = val
end

def and(env, opts)
  target, value1, value2 = opts
  v1 = v(env, value1)
  v2 = v(env, value2)
  return false unless v1 && v2
  env[target] = v1 & v2
end

def or(env, opts)
  target, value1, value2 = opts
  v1 = v(env, value1)
  v2 = v(env, value2)
  return false unless v1 && v2
  env[target] = v1 | v2
end

def lshift(env, opts)
  target, value1, value2 = opts
  v1 = v(env, value1)
  v2 = v(env, value2)
  return false unless v1 && v2

  env[target] = v1 << v2
end

def rshift(env, opts)
  target, value1, value2 = opts
  v1 = v(env, value1)
  v2 = v(env, value2)
  return false unless v1 && v2

  env[target] = v1 >> v2
end

def run(lines, env = {})
  instructions = lines.map {|l| parse_line(l)}
  while instructions.any? do
    instructions = instructions.reject do |instruction|
      command = instruction[0]
      send(command, env, instruction[1..-1])
    end
  end
  env
end

sample = <<~TXT
NOT x -> h
NOT y -> i
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
TXT

# puts run(sample.lines)
result = run(data.lines)
puts "Part 1: #{result['a']}"
puts "Part 2: #{run(data.lines, {'b' => 46065})['a']}"