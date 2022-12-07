def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

SAMPLE = <<~TEXT
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
TEXT
def bottom(data)
  programs = data.strip.lines.map do |line|
    tokens = line.strip.split(/\s+/)
    {name: tokens[0], weight: tokens[1].scan(/\d+/).first.to_i, subs: Array(tokens[3..-1]).map {|n| n.gsub(',', '')}}
  end
  # puts programs.flat_map {|n| n[:subs]}

  (programs.map {|n|n[:name]} - programs.flat_map {|n| n[:subs]}).first
end

assert_equal('tknk', bottom(SAMPLE))
puts "Part 1: #{bottom(DATA)}"