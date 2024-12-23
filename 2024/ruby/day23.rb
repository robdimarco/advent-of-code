TEST_DATA = <<~DATA
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(data)
  hsh = Hash.new { |h, k| h[k] = [] }

  data.each_line do |line|
    a, b = line.strip.split("-")
    hsh[a] << b
    hsh[b] << a
  end
  hsh
end

def part1(data)
  hsh = parse(data)

  conns = []
  hsh.each do |(k,v)|
    v.each do |vv|
      hsh[vv].each do |vvv|
        if v != k && v.include?(vvv)
          conns.push([k, vv, vvv])
        end
      end
    end
  end
  conns.map(&:sort).uniq.select {|conn| conn.any?{|v| v[0] == 't'}}.size
end

# for each key sorted
#   look at the connections that come after it.
#   each of these connections must be in a group with the key
#   if we look through the existing connections and all elements of the connection are shared, add this to that group
#   otherwise add a new group

def part2(data)
  hsh = parse(data)
  conns = []
  keys = hsh.keys.sort
  keys.each do |k|
    vals = hsh[k].select {|v| v > k}
    vals.each do |v|
      c = conns.find do |conn|
        conn.all? {|c| hsh[v].include?(c)}
      end
      if c
        c.push(v)
      else
        conns.push([k,v])
      end
    end
  end
  conns.sort_by(&:size).reverse.first.sort.join(',')
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
