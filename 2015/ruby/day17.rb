def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day17.txt')
sample = <<~TXT
20
15
10
5
5
TXT

def matches(containers, amt)
  containers = containers.lines.map(&:to_i)
  matches = []
  containers.size.times do |i|
    containers.combination(i + 1).each do |combo|
      matches << combo if combo.sum == amt
    end
  end
  matches.size
end

def min_matches(containers, amt)
  containers = containers.lines.map(&:to_i)
  matches = []
  containers.size.times do |i|
    containers.combination(i + 1).each do |combo|
      matches << combo if combo.sum == amt
    end
  end
  min_match_num = matches.map(&:size).min
  min_matches = matches.select {|m| m.size == min_match_num}
  # puts "#{min_match_num}, #{min_matches.inspect}"
  min_matches.size
end

assert_equal(4, matches(sample, 25))
puts "Part 1 #{matches(data, 150)}"

assert_equal(3, min_matches(sample, 25))
puts "Part 2 #{min_matches(data, 150)}"