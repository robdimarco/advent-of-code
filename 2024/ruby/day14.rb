TEST_DATA = <<~DATA
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(data)
  data.lines.map do |l|
    x,y,vx,vy = l.scan(/\-?\d+/)
    [Complex(x.to_i, y.to_i), Complex(vx.to_i, vy.to_i)]
  end
end

def move(data, times, x, y)
  data.map do |(p, v)|
    nv = p + (v * times)
    Complex(nv.real % x, nv.imag % y)
  end
end

def part1(data, times, x, y)
  data = parse(data)
  cnts = Hash.new(0)
  vals = move(data, times, x, y)
  vals.map do |v|
    if v.real < x/2 && v.imag < y/2
      cnts[0] += 1
    elsif v.real > x/2 && v.imag < y/2
      cnts[1] += 1
    elsif v.real < x/2 && v.imag > y/2
      cnts[2] += 1
    elsif v.real > x/2 && v.imag > y/2
      cnts[3] += 1
    end
  end
  cnts.values.reduce(&:*)
end

def plot(vals, x, y)
  cnts = Hash.new(0)
  vals.each do |v|
    cnts[v] += 1
  end

  y.times do |yy|
    x.times do |xx|
      v = cnts[Complex(xx, yy)]
      if v == 0
        print '.'
      else
        print v.to_s
      end
    end
    puts
  end
end

def part2(data, times, x, y)
  (1..times).each do |n|
    vals = move(parse(data), n, x, y)
    cnts = Hash.new(0)
    vals.each do |v|
      cnts[v] += 1
    end
    if cnts.values.max <= 1
      puts "********* AT TIMES #{n} ************"
      puts plot(vals, x, y) 
      puts
    end
  end    
end

# puts part1(TEST_DATA, 100, 11, 7)
# puts part1(REAL_DATA, 100, 101, 103)

part2(REAL_DATA, 1_000_000, 101, 103)