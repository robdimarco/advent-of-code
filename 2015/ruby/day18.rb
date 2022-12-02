def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day18.txt')

sample = <<~TXT
.#.#.#
...##.
#....#
..#...
#.#..#
####..
TXT

def parse(data)
  data.lines.map do |l|
    l.strip.chars.map {|c| c == '.' ? 0 : 1}
  end
end

def visualize(lights)
  lights.map do |row|
    row.map {|l| l == 1 ? '#' : '.'}.join
  end.join("\n")
end

def lit_neighbors(start, x, y)
  cnt = 0
  [x-1, x, x+1].each do |nx|
    next if nx < 0 || nx >= start.size
    [y-1, y, y+1].each do |ny|
      next if ny < 0 || ny >= start[nx].size
      next if nx == x && ny == y

      cnt += start[nx][ny]
    end
  end
  cnt
end

def evaluate(start, corners_on=false)
  rv = []
  start.each_with_index do |row, x|
    rv.push([])
    row.each_with_index do |old_val, y|
      cnt = lit_neighbors(start, x, y)
      new_val = if old_val == 1
        cnt == 2 || cnt == 3 ? 1 : 0
      else
        cnt == 3 ? 1 : 0
      end
      if corners_on && [
        [0,0], [0,row.size - 1], [start.size - 1, 0], [start.size - 1, row.size - 1]
      ].include?([x,y])
        new_val = 1
      end
      rv[-1].push(new_val)
    end
  end
  rv
end

def iterate(start, steps, corners_on=false)
  lights = parse(start)
  steps.times { lights = evaluate(lights, corners_on)}
  lights
end

assert_equal(<<~TXT.strip, visualize(iterate(sample, 1)))
..##..
..##.#
...##.
......
#.....
#.##..
TXT

assert_equal(<<~TXT.strip, visualize(iterate(sample, 2)))
..###.
......
..###.
......
.#....
.#....
TXT

assert_equal(<<~TXT.strip, visualize(iterate(sample, 3)))
...#..
......
...#..
..##..
......
......
TXT

assert_equal(<<~TXT.strip, visualize(iterate(sample, 4)))
......
......
..##..
..##..
......
......
TXT

puts "Part 1 "
puts iterate(data, 100).flatten.sum

puts "Part 2"
puts iterate(data, 100, true).flatten.sum