sample=<<~TXT.lines.map(&:strip)
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
TXT
real = File.open("day24.txt").read.lines

def parse(lines)
  lines.map do |line|
    a, b = line.split(' @ ')
    x, y, z = a.split(', ').map(&:to_i)
    vx, vy, vz = b.split(', ').map(&:to_i)
    [[x, y, z], [vx, vy, vz]]
  end
end

def xy_intersect(pos1, pos2, v1, v2)
  a = v1[0]
  b = pos1[0]
  c = v1[1]
  d = pos1[1]
  e = v2[0]
  f = pos2[0]
  g = v2[1]
  h = pos2[1]

  x = ((a * e * d) - (b * c * e) - (a * e * h) + (a * f * g))/ ((a*g) - (c*e)).to_f
  y = (g * (x - f) / e) + h
  t = y 

  [x, y, (x-b).to_f/a, (x-f).to_f/e]
end

def xy_parallel?(v1, v2)
  a = v1[0]
  c = v1[1]
  e = v2[0]
  g = v2[1]
  (a*g) == (c*e)
end

def part1(data, min, max)
  lines = parse(data)
  cnt = 0
  lines.each_with_index do |l1, i|
    j = i + 1
    loop do
      break if j >= lines.size
      l2 = lines[j]
      x, y, t1, t2 = xy_intersect(l1[0], l2[0], l1[1], l2[1])
      # puts "Check on #{[i, j]} at #{[x, y]} for #{l1} and #{l2}"
      if x >= min && x <= max && y >= min && y <= max && !xy_parallel?(l1[1], l2[1]) && t1 > 0 && t2 > 0
        cnt += 1 
        # puts "Match on #{i} == #{j} at #{[x, y]} at time #{t1} / #{t2} for #{l1} and #{l2}"
      end
      j+=1
    end
  end
  cnt
end

def part2(data)
end

puts part1(sample, 7, 27)
puts part1(real, 200000000000000, 400000000000000)


# puts part2(sample)
# puts part2(real)