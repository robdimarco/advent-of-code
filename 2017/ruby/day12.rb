def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
TEXT
def groups(data)
  nodes = []
  edges = []
  data.lines.map do |l|
    a, other = l.split(' <-> ')
    a = a.to_i
    nodes << a
    conns = other.split(', ').map(&:to_i).each do |b|
      edges << [a, b]
    end
  end

  groups = nodes.map {|n| [n]}
  edges.each do |e|
    a, b = e
    ga = groups.find {|g| g.include?(a)}
    gb = groups.find {|g| g.include?(b)}
    if ga != gb
      ga.push(*gb)
      groups.delete(gb)
    end
  end
  groups
end
def size(data)
  groups(data).detect {|g| g.include?(0)}.size
end
def count(data)
  groups(data).size
end

assert_equal(6, size(SAMPLE))
puts "Part 1 #{size(DATA)}"
assert_equal(2, count(SAMPLE))
puts "Part 2 #{count(DATA)}"