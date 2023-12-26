sample=<<~TXT.lines.map(&:strip)
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
TXT
real = File.open("day25.txt").read.lines.map(&:strip)

def parse(lines)
  rv = Hash.new { |h, k| h[k] = [] }
  lines.each do |line|
    a, b = line.split(': ')
    b.split(' ').each do |c|
      rv[a].push(c)
      rv[c].push(a)
    end
  end
  rv
end

require 'set'
def groups(graph)
  unchecked = graph.keys.dup
  checked = Set.new
  groups = []
  loop do
    return groups if unchecked.empty?

    a = unchecked.shift
    checked.add(a)
    group = [a]

    groups.push(group)
    to_check = graph[a].dup
    until to_check.empty? do
      b = to_check.shift
      next if checked.include?(b)
      checked.add(b)
      unchecked.delete(b)
      group.push(b)
      to_check = to_check.concat(graph[b])
    end
  end

  groups
end
require 'algorithms'
def shortest_path(src, dest, graph)
  to_check = Containers::PriorityQueue.new
  checked = {}
  to_check.push([src, [src]], 0)

  loop do
    node, path = to_check.pop
    return path if node == dest
    next if checked[node] && checked[node].size <= path.size
    checked[node] = path

    graph[node].each do |n|
      to_check.push([n, path + [n]], -path.size)
    end
  end
  nil
end

def part1(data)
  rv = {}
  
  graph = parse(data)
  cnts = Hash.new(0)

  1000.times do
    k1 = graph.keys.sample
    k2 = graph.keys.sample
    next if k1 == k2
    pt = shortest_path(k1, k2, graph)
    (0..pt.size - 2).each do |i| 
      key = [pt[i], pt[i + 1]].sort
      cnts[key] += 1
    end
  end
  cuts = cnts.keys.sort_by {|k| -cnts[k]}[0..2]
  g = graph.dup
  cuts.each do |k1, k2|
    g[k1].delete(k2)
    g[k2].delete(k1)
  end
  gg = groups(g)

  if gg.size == 2 && gg.map(&:size).min > 1
    puts "#{cnts} gives groups #{gg}"
    return gg.map(&:size).reduce(&:*)
  end
  -1
end

def part2(data)
end

puts part1(sample)
puts part1(real)


puts part2(sample)
puts part2(real)