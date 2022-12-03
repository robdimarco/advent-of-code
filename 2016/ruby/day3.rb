data = File.read('day3.txt')
lines = data.lines.map do |line|
  line.strip.split(/\s+/).map(&:to_i).sort
end

puts "Part 1: #{lines.select { |(a,b,c)| a+b > c}.size}"