TEST_DATA = <<~DATA
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
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
  [course, start, finish, data.lines.size, data.lines[0].size]
end
require 'algorithms'
DIRS = [1, -1, 1i, -1i]
def md(a,b)
  (a.real - b.real).abs - (a.imag - b.imag).abs
end

def find_dist(course, start, finish, max_r, max_i)
  visited = {finish => 0}
  to_check = Containers::PriorityQueue.new
  to_check.push(finish, 0)
  until to_check.empty? do
    pos = to_check.pop
    DIRS.each do |dir|
      npos = pos + dir
      if npos.real > 0 && npos.imag > 0 && npos.real < max_r && npos.imag < max_i && !course.key?(npos)
        if visited[npos].nil? || visited[npos] > visited[pos] + 1 
          visited[npos] = visited[pos] + 1 
          to_check.push(npos, -1 * md(npos, finish))
        end
      end
    end
  end
  visited
end

def part1(data, min_save)
  course, start, finish, max_r, max_i = parse(data)
  dist_from_finish = find_dist(course, start, finish, max_r, max_i)
  dist_from_start = find_dist(course, finish, start, max_r, max_i)
  reg_leng = dist_from_finish[start]
  rv = Hash.new(0)
  course.keys.each do |wall|
    DIRS.each do |k|
      require 'debug'
      # binding.break if wall == 7+6i
      a = wall - k
      b = wall + k
      if dist_from_start.key?(a) && dist_from_finish.key?(b)
        savings = reg_leng - (dist_from_start[a] + dist_from_finish[b] + 2)
        rv[savings] += 1 if savings > 0
      end
    end
  end
  rv.keys.map {|k| k >= min_save ? rv[k] : 0}.sum
end
puts part1(TEST_DATA, 0)
puts part1(REAL_DATA, 100)