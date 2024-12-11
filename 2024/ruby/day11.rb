TEST_DATA = "125 17".split(" ")
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt").split(" ")

def turn(data)
  rv = []
  data.each do |n|
    if n == "0"
      rv.push("1")
    elsif n.size % 2 == 0
      n1 = n[0...(n.size/2)]
      rv.push(n1.to_i.to_s)
      n1 = n[(n.size/2)..-1]
      rv.push(n1.to_i.to_s)
    else
      rv.push((n.to_i * 2024).to_s)
    end
  end
  rv
end

def part1(data)
  25.times do 
    data = turn(data)
  end
  data.size
end

def part2(data)
  75.times do 
    print '.'
    data = turn(data)
  end
  data.size
end

# puts part1(TEST_DATA)
# puts part1(REAL_DATA)
# puts part2(TEST_DATA)
puts part2(REAL_DATA)
