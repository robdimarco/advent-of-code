
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

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
