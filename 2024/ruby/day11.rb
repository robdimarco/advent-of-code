TEST_DATA = "125 17".split(" ")
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt").split(" ")

def turn(data)
  rv = Hash.new(0)
  data.each do |n,v|
    if n == "0"
      rv["1"] += v
    elsif n.size % 2 == 0
      n1 = n[0...(n.size/2)].to_i.to_s
      n2 = n[(n.size/2)..-1].to_i.to_s
      rv[n1] += v
      rv[n2] += v
    else
      rv[(n.to_i * 2024).to_s] += v
    end
  end
  rv
end
def parse(data)
  rv = Hash.new(0)
  data.each do |n|
    rv[n] += 1
  end
  rv
end
def run(data, n)
  data = parse(data)
  n.times do
    data = turn(data)
  end
  data.values.sum
end

puts run(TEST_DATA, 25)
puts run(REAL_DATA, 25)
puts run(REAL_DATA, 75)
