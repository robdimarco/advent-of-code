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
        if data[r1][c] == 'O' && data[r2][c] == '.'
          data[r1][c] = '.'
          data[r2][c] = 'O'
        end
      end
    end
  end
  data
end

def rotate(data)
  rv = []
  data[0].size.times { rv.push([] * data.size) }
  data.each_with_index do |r, col|
    r.each_with_index do |c, row|
      rv[row][r.size - col - 1] = c
    end
  end
  rv
end

def cycle(data, cache)
  return cache[data] if cache[data]
  data = tilt_north(data)
  3.times do 
    data = tilt_north(rotate(data))
  end
  cache[data] = rotate(data)
end

def part1(lines)
  load(tilt_north(parse(lines)))
end

def part2(lines) 
  cache = {}
  rotation_cache = {}
  data = parse(lines)
  i = 1
  target = 1_000_000_000
  loop do
    data = cycle(data, rotation_cache)
    key = data.map(&:join).join("\n")
    if cache[key]
      # puts "Found repeat at #{i} from #{cache[key]}"
      left = (target - i) % (i - cache[key])
      # puts "At #{i} matching #{cache[key]} give #{left} #{cache.inspect}"
      d = cache.to_a.map(&:reverse).to_h[cache[key] + left]

      return load(parse(d.lines))
    end

    cache[key] = i
    i += 1
  end
  # puts "Found repeat at #{i}"
  load(data)
end

# puts part1(sample)
# puts part1(real)

puts part2(sample)
puts part2(real)

