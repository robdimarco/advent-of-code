TEST_DATA =<<~DATA.lines.map(&:strip)
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt").lines.map(&:strip)

def part1(data)
  freqs = Hash.new {|h, k| h[k] = []}
  data.each_with_index do |row, r|
    row.chars.each_with_index do |v, c|
      freqs[v] << [r, c] if v != '.'
    end
  end
  points = []
  freqs.each do |_, vals|
    combos = vals.combination(2).to_a
    combos.each do |(r1, c1), (r2, c2)|
      dr = (r1 - r2)
      dc = (c1 - c2)
      a1 = [r1 + dr, c1 + dc]
      a2 = [r2 - dr, c2 - dc]
      # puts "for [#{r1}, #{c1}] and [#{r2}, #{c2}], points of #{a1.inspect} #{a2.inspect}"
      [a1, a2].each do |a|
        points.push(a) if a[0] >= 0 && a[1] >= 0 && a[0] < data.size && a[1] < data.size
      end
    end
  end
  points.uniq.size
end

def part2(data)
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)
# puts part2(TEST_DATA)
# puts part2(REAL_DATA)
