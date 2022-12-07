def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day2.txt')

SAMPLE = <<~TEXT
5 1 9 5
7 5 3
2 4 6 8
TEXT

def cksum(data)
  data.lines.sum do |row|
    i = row.split(/\s+/).map(&:to_i)
    # puts "#{i.min}, #{i.max}"
    i.max - i.min
  end
end
assert_equal(18, cksum(SAMPLE))

puts "Part 1 #{cksum(DATA)}"

SAMPLE2 = <<~TEXT
5 9 2 8
9 4 7 3
3 8 6 5
TEXT

def cksum2(data)
  sum = 0
  data.lines.each do |row|
    nums = row.split(/\s+/).map(&:to_i)
    nums.combination(2).map do |(a,b)|
      puts "Checking #{a} / #{b}"
      n = if a % b == 0
        a/b
      elsif b % a == 0
        b/a
      end
      if n
        puts "match"
        sum += n
        break
      end
    end
  end
  sum
end
assert_equal(9, cksum2(SAMPLE2))

puts "Part 1 #{cksum2(DATA)}"