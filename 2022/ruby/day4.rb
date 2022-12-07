def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day4.txt')
sample = <<~TXT
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
TXT

def full_overlap(data)
  data.lines.map do |l|
    e1, e2 = l.strip.split(',')
    e1b, e1e = e1.split('-').map(&:to_i)
    e2b, e2e = e2.split('-').map(&:to_i)

    r1 = (e1b..e1e).to_a
    r2 = (e2b..e2e).to_a
    if r1 & r2 == r1 || r2 & r1 == r2
      1
    else
      0
    end
  end.sum
end

def any_overlap(data)
  data.lines.map do |l|
    e1, e2 = l.strip.split(',')
    e1b, e1e = e1.split('-').map(&:to_i)
    e2b, e2e = e2.split('-').map(&:to_i)

    r1 = (e1b..e1e).to_a
    r2 = (e2b..e2e).to_a
    if (r1 & r2).any? || (r2 & r1).any?
      1
    else
      0
    end
  end.sum
end

assert_equal(2, full_overlap(sample))
puts "Part 1 #{full_overlap(data)}"

assert_equal(4, any_overlap(sample))

puts "Part 2 #{any_overlap(data)}"
