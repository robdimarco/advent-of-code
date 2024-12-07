TEST_DATA =<<~DATA.lines.map(&:strip)
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
DATA
REAL_DATA = File.read('day7.txt').lines.map(&:strip)

def parse(lines)
  lines.map do |l|  
    a, b = l.split(':')
    a = a.to_i
    b = b.split(' ').reject(&:empty?).map(&:to_i)
    [a, b]
  end
end

def valid?(a, b)
  n = 2 ** (b.size - 1)
  return a == b[0] if b.size == 1
  (0...n).each do |i|
    vals = i.to_s(2).rjust(b.size).reverse.chars.map(&:to_i)
    n = b[0]
    debug = "#{n}"
    (1...b.size).each do |j|
      op = vals[j - 1].to_i
      if op == 0
        n = n + b[j]
        debug += " + #{b[j]}"
      else
        n = n * b[j]
        debug += " * #{b[j]}"
      end
    end
    # puts "Got #{n} for #{debug} =? #{a}: #{vals}" 
    return true if n == a
  end
  false
end

def part1(data)
  parse(data).select{|a, b| valid?(a, b)}.map{|a,b| a}.sum
end

def part2(data)
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)
