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
  # puts programs.flat_map {|n| n[:weight]}.inspect

  (programs.map {|n|n[:name]} - programs.flat_map {|n| n[:subs]}).first
end

def total_weight(name, programs)
  target = programs[name]
  return target[:total_weight] if target[:total_weight]

  wts = target[:subs].map {|n| total_weight(n, programs) }
  target[:sub_wts] = Array(wts)
  # puts "#{name} = #{wts.sum} + #{target[:weight]}"
  target[:total_weight] = wts.sum + target[:weight]
end

def missing_weight(data)
  programs = data.strip.lines.each_with_object({}) do |line, hsh|
    tokens = line.strip.split(/\s+/)
    hsh[tokens[0]] = {name: tokens[0], weight: tokens[1].scan(/\d+/).first.to_i, subs: Array(tokens[3..-1]).map {|n| n.gsub(',', '')}}
  end
  programs.each {|name, program| total_weight(name, programs)}
  bad = programs.values.sort_by {|p| p[:total_weight]}.find {|p| p[:sub_wts].uniq.size > 1}
  single, multi = bad[:sub_wts].tally.partition {|_,v| v == 1}
  bad_wt = single[0][0]
  gd_wt = multi[0][0]

  bad_p = bad[:subs].map {|n| programs[n]}.find {|p| p[:total_weight] == bad_wt}
  bad_p[:weight] - bad_wt + gd_wt
end

assert_equal('tknk', bottom(SAMPLE))
puts "Part 1: #{bottom(DATA)}"

assert_equal(60, missing_weight(SAMPLE))
puts "Part 2: #{missing_weight(DATA)}"
