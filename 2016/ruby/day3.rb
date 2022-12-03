data = File.read('day3.txt')
lines = data.lines.map do |line|
  line.strip.split(/\s+/).map(&:to_i)
end

puts "Part 1: #{lines.map(&:sort).select { |(a,b,c)| a+b > c}.size}"
puts lines[-1].inspect
triangles = []
3.times do |n|
  lines.each_with_index do |a, idx|
    if idx % 3 == 0
      triangles.push([])
  # puts [n, idx].inspect
    end
    triangles[-1].push(a[n])
  end
  # puts triangles.size
end

valid = triangles.select do |t|
  a,b,c = t.sort
  a+b > c
end
puts valid.size
