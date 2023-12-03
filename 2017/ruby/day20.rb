def particles(str)
  i = -1
  str.lines.map do |line|
    v = line.scan(/[\-\d]+/).map(&:to_i)
    i += 1
    [
      i,
      v[0..2],
      v[3..5],
      v[6..8]
    ]
  end
end


def part1(data)
  ps = particles(data)
  10000.times do 
    ps.each do |part|
      2.times do |y|
        3.times do |n|
          part[2-y][n] += part[3-y][n]
        end
      end
    end
  end
  ps.sort_by {|p| p[1].map(&:abs).sum}.first.first
end

# puts part1("p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>\np=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>").inspect
# puts part1(File.read("day20.txt")).inspect



def part2(data)
  ps = particles(data)
  10000.times do |n|
    ps.each do |part|
      2.times do |y|
        3.times do |n|
          part[2-y][n] += part[3-y][n]
        end
      end
    end
    currentPos = Hash.new {|h,k| h[k] = []}
    ps.each do |p|
      currentPos[p[1]].push(p[0])
    end
    ps = ps.select do |p|
      currentPos[p[1]].size == 1
    end
    puts ps.size if n % 10 == 0
  end
  ps.size
end
puts part2(<<~TEXT)
p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
TEXT
puts part2(File.read("day20.txt")).inspect
