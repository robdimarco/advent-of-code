def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day3.txt')
sample = <<~TXT
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
TXT

def priority_sum(data)
  chars = data.lines.map do |line|
    line.strip!
    p1 = line[0...(line.size / 2)]
    p2 = line[(line.size / 2)..-1]
    (p1.chars & p2.chars).first
  end
  chars.map do |c|
    if c == c.downcase
      c.ord - 'a'.ord + 1
    else
      c.ord - 'A'.ord + 27
    end
  end.sum
end

def badge_sum(data)
  rucks = []
  data.lines.each_with_index do |line, idx|
    if idx % 3 == 0
      rucks.push([])
    end
    rucks[-1].push(line.strip)
  end

  chars = rucks.map do |r|
    r.reduce(r[0].chars) {|acc, c| acc & c.chars}.first
  end

  chars.map do |c|
    if c == c.downcase
      c.ord - 'a'.ord + 1
    else
      c.ord - 'A'.ord + 27
    end
  end.sum
end

assert_equal(157, priority_sum(sample))
puts "Part 1: #{priority_sum(data)}"
assert_equal(70, badge_sum(sample))
puts "Part 2: #{badge_sum(data)}"
