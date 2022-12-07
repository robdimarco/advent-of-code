data = File.read('day1.txt')
# data = <<~TXT
# 1000
# 2000
# 3000

# 4000

# 5000
# 6000

# 7000
# 8000
# 9000

# 10000
# TXT
data = data.lines.map(&:strip)

ar = [[]]
data.each do |line|
	if line == ""
		ar.push([])
	else
		ar[-1].push(line.to_i)
	end
end
puts ar.map(&:sum).sort.reverse[0..2].sum
