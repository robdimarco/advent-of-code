sample=<<~TXT.lines.map(&:strip)
Time:      7  15   30
Distance:  9  40  200
TXT

real = File.open("day6.txt").read.lines.map(&:strip)

def part1(data)
  times = data[0].scan(/\d+/).map(&:to_i)
  distances = data[1].scan(/\d+/).map(&:to_i)
  pairs = times.zip(distances)

  pairs.map do |(t, d)|
    (0..t).filter do |n|
      n * (t - n) > d
    end.size
  end.reduce(:*)
end

def part2(data)
  t = data[0].scan(/\d+/).join.to_i
  d = data[1].scan(/\d+/).join.to_i
  (0..t).filter do |n|
    n * (t - n) > d
  end.size
end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real)
