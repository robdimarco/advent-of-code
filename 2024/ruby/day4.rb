TEST_DATA =<<~DATA.lines.map(&:strip)
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
DATA
REAL_DATA = File.read('day4.txt').lines.map(&:strip)

def part1(data)
  cnt = 0
  to_check = []
  (0...data.size).each do |r|
    (0...data[r].size).each do |c|
      [-1, 0, 1].each do |dr|
        [-1, 0, 1].each do |dc|
          to_check.push([r, c, dr, dc, ""]) unless dr == 0 && dc == 0
        end
      end
    end
  end
  until to_check.empty? do
    r, c, dr, dc, s = to_check.pop
    v = data[r][c]
    case (s+v)
    when "X", "XM", "XMA"
      nr = r + dr
      next if nr < 0 || nr >= data.size
      nc = c + dc
      next if nc < 0 || nc >= data[nr].size
      to_check.push([nr, nc, dr, dc, s + v])
    when "XMAS"
      cnt += 1
    end
  end
  cnt
end

def part2(data)
  cnt = 0
  to_check = []
  (0...data.size - 2).each do |r|
    (0...data[r].size - 2).each do |c|
      to_check.push([r, c])
    end
  end

  until to_check.empty? do
    r, c = to_check.pop
    case data[r][c]
    when 'M'
      if data[r + 1][c + 1] == 'A' &&
        data[r + 2][c] == 'M' &&
        data[r][c + 2] == 'S' &&
        data[r + 2][c + 2] == 'S' 
        cnt += 1
      end
      if data[r + 1][c + 1] == 'A' &&
        data[r][c + 2] == 'M' &&
        data[r + 2][c] == 'S' &&
        data[r + 2][c + 2] == 'S' 
        cnt += 1
      end
    when 'S'
      if data[r + 1][c + 1] == 'A' &&
        data[r + 2][c] == 'S' &&
        data[r][c + 2] == 'M' &&
        data[r + 2][c + 2] == 'M'
        cnt += 1
      end
      if data[r + 1][c + 1] == 'A' &&
        data[r][c +2] == 'S' &&
        data[r + 2][c] == 'M' &&
        data[r + 2][c + 2] == 'M'
        cnt += 1
      end
    end
  end
  cnt
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)