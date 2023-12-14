sample=<<~TXT.lines.map(&:strip)
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
TXT

real = File.open("day14.txt").read.lines.map(&:strip)

tilted =<<~TXT.lines.map(&:strip)
OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
TXT

def parse(lines)
  lines.map(&:chars)
end

def load(data)
  rv = 0
  data.each_with_index do |row, idx|
    rv += row.select {|c| c == 'O'}.size * (data.size - idx)
  end
  rv
end

def tilt_north(data)
  (data.size).times do |i|
    r = i
    data[r].size.times do |c|
      i.times do |n|
        r1 = r - n
        r2 = r - n - 1
        # puts "Checking [#{r1}, #{c}] against [#{r2}, #{c}]"
        if data[r1][c] == 'O' && data[r2][c] == '.'
          data[r1][c] = '.'
          data[r2][c] = 'O'
        end
      end
    end
  end
  data
end
# puts tilt_north(parse(real))

def part1(lines)
  load(tilt_north(parse(lines)))
end

def part2(lines)  
end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real)

