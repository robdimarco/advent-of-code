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

def part1(data)
  hsh = Hash.new { |h, k| h[k] = [] }

  data.each_line do |line|
    a, b = line.strip.split("-")
    hsh[a] << b
    hsh[b] << a
  end

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
puts part1(TEST_DATA)
puts part1(REAL_DATA)
