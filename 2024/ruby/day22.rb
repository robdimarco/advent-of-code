TEST_DATA = <<~DATA
1
10
100
2024
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")

def mix(a, b)
  a ^ b
end

def prune(a)
  a % 16777216
end

def evolve(num)
  num = prune(mix(num * 64, num))
  num = prune(mix(num / 32, num))
  prune(mix(num * 2048, num))  
end

def part1(data, iters)
  data.lines.map do |line|
    n = line.to_i
    iters.times do 
      n = evolve(n)
    end
    n
  end.sum
end

def secrets_from_line(line, iters)
  n = line.to_i
  secrets = [n]
  secrets += (0...iters).map do
    n = evolve(n)
  end
end

def diffs_from_secrets(secrets)
  (1...secrets.size).map do |idx| 
    (secrets[idx] % 10) - (secrets[idx - 1] % 10)
  end
end

def bananas_by_sequence(line, iters)
  hsh = Hash.new {|h,k| h[k] = []}
  secrets = secrets_from_line(line, iters)
  diffs = diffs_from_secrets(secrets)
  (0...diffs.size - 4).each do |idx|
    seq = diffs[idx..idx+3]
    val = secrets[idx+4] % 10
    hsh[seq].push(val)
  end
  hsh
end

require 'debug'
def part2(data, iters)
  mappings = []
  data.lines.map do |line|
    mappings.push(bananas_by_sequence(line, iters))
  end

  summer = Hash.new(0)
  mappings.each do |hsh|
    hsh.each do |k, v|
      summer[k] += v[0]
    end
  end
  # binding.break
  summer.values.sort.reverse[0]
end
# puts part1(TEST_DATA, 2000)
# puts part1(TEST_DATA, 2000)
TEST_DATA_2 = <<~DATA
1
2
3
2024
DATA
puts part2(TEST_DATA_2, 2000)
puts part2(REAL_DATA, 2000)
