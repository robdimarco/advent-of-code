def part1(data)
  data.lines.map {|l| a = l.scan(/\d/); [a[0], a[-1]].join.to_i}.sum
end

puts part1("""1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""")

puts part1(File.open("day1.txt").read)


def part2(data)
  nums = %w(one two three four five six seven eight nine)
  nums2 = nums.map {|w| w.reverse}

  data.lines.map do |line|
    line.strip!
    ex = %r{#{nums.join("|")}|\d}
    ex2 = %r{#{nums2.join("|")}|\d}
    f = line.scan(ex).first
    l = line.reverse.scan(ex2).first
    f = (1 + nums.index(f)).to_s if nums.include?(f)
    l = (1 + nums2.index(l)).to_s if nums2.include?(l)
    v = (f.to_s + l.to_s).to_i
    # puts "#{line} => #{v}"
    v
  end.sum

end

puts part2 """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""

puts part2(File.open("day1.txt").read)
