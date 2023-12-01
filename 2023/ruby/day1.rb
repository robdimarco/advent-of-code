def day1(data)
  data.lines.map {|l| a = l.scan(/\d/); [a[0], a[-1]].join.to_i}.sum
end

puts day1("""1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""")

puts day1(File.open("day1.txt").read)