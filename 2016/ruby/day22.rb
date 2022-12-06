def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day22.txt')
SAMPLE = <<~TEXT
root@ebhq-gridcenter# df -h
Filesystem              Size  Used  Avail  Use%
/dev/grid/node-x0-y0     87T   71T    16T   81%
/dev/grid/node-x0-y1     93T   72T    21T   77%
/dev/grid/node-x0-y2     87T   67T    20T   77%
/dev/grid/node-x0-y3     87T   87T     0T   77%
/dev/grid/node-x0-y3     87T    0T    87T   100%
TEXT
Node = Struct.new(:x, :y, :total, :used, :avail) do
  def empty?
    used == 0
  end
end

def parse(line)
  match = /node\-x(\d+)\-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/.match(line)
  return unless match
  Node.new(match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i, match[5].to_i)
end
assert_equal(Node.new(0, 0, 87, 71, 16), parse("/dev/grid/node-x0-y0     87T   71T    16T   81%"))

def pairs(data)
  nodes = data.lines.map{|l| parse(l)}.compact
  count = 0
  nodes.each do |a|
    nodes.each do |b|
      if !a.empty? && a != b && a.used <= b.avail
        count += 1 
      end
    end
  end
  count
end

assert_equal(4, pairs(SAMPLE))
puts "Part 1: #{pairs(DATA)}"
