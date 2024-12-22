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
puts part1(TEST_DATA, 2000)
puts part1(REAL_DATA, 2000)