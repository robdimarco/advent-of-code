TEST_DATA = <<~DATA
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(data)
  course = {}
  start = nil
  finish = nil
  data.lines.each_with_index do |l, r|
    l.strip.chars.each_with_index do |ch, c|
      if ch == "#"
        course[Complex(r, c)] = ch
      elsif ch == "S"
        start = Complex(r,c)
      elsif ch == "E"
        finish = Complex(r,c)
      end
    end
  end
  [course, start, finish]
end

def part1(data)
  course, start, finish = parse(data)

  visited = {}
  to_check = [[start, 0 + 1i, 0]]
  rv = nil
  while to_check.any?
    pos, dir, cost = to_check.shift
    # puts "Checking #{pos}, #{dir}, #{cost}"
    next if course[pos] == "#" # At wall... not valid
    if !visited.key?([pos, dir]) || visited[[pos, dir]] > cost
      visited[[pos, dir]] = cost
      if pos != finish
        to_check.push([pos + dir, dir, cost + 1])
        to_check.push([pos, dir * 1i, cost + 1_000])
        to_check.push([pos, dir * -1i, cost + 1_000])
      else 
        rv = [rv, cost].compact.min
      end
    end
  end
  rv
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)