
TEST_DATA =<<~DATA
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
DATA
REAL_DATA = File.read('day11.txt')
require 'algorithms'

def parse(data)
  paths = {}
  data.lines.map do |line|
    a, b = line.split(':')
    paths[a] = b.split(' ')
  end
  paths
end

def part1(data)
  connections = parse(data)
  pq = Containers::PriorityQueue.new
  cnt = 0
  pq.push(["you"], 0)
  until pq.empty?
    paths = pq.pop
    last = paths[0]
    if last == "out"
      cnt +=1
      next
    end
    connections[last].each do |c|
      pq.push([c] + paths, paths.size)
    end
  end
  cnt
end

TEST_DATA_2 = <<~DATA
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
DATA

def path_count(connections, counts, src, target)
  return 1 if src == target
  return 0 unless connections[src]
  k = [src, target]
  return counts[k] if counts[k]
  cnt = 0
  connections[src].each do |n|
    cnt += path_count(connections, counts, n, target)
  end
  counts[k] = cnt
end

def part2(data)
  counts = {}
  connections = parse(data)
  a1 = path_count(connections, counts, "svr", "fft")
  b1 = path_count(connections, counts, "fft", "dac")
  c1 = path_count(connections, counts, "dac", "out")

  a2 = path_count(connections, counts,"svr", "dac")
  b2 = path_count(connections, counts,"dac", "fft")
  c2 = path_count(connections, counts,"fft", "out")
  (a1 * b1 * c1) + (a2 * b2 * c2)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA_2)
puts part2(REAL_DATA) 
