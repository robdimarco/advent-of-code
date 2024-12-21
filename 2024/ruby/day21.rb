TEST_DATA = <<~DATA
029A
980A
179A
456A
379A
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
require 'algorithms'

NUMPAD = {
  0 + 0i => "7",
  1i => "8",
  2i => "9",
  1 + 0i => "4",
  1 + 1i => "5",
  1 + 2i => "6",
  2 + 0i => "1",
  2 + 1i => "2",
  2 + 2i => "3",
  3 + 1i => "0",
  3 + 2i => "A",
}
R_NUMPAD = NUMPAD.invert

TOUCHPAD = {
  1i => "^",
  2i => "A",
  1 + 0i => "<",
  1 + 1i => "v",
  1 + 2i => ">",
}
R_TOUCHPAD = TOUCHPAD.invert

TOUCHPAD_TO_DIR = {
  "^" => -1 + 0i,
  "v" => 1 + 0i,
  "<" => -1i,
  ">" => 1i,
}
DIR_TO_TOUCHPAD = TOUCHPAD_TO_DIR.invert
DIRS = [1, -1, 1i, -1i]

def md(a, b)
  (a.real - b.real).abs + (a.imag + b.imag).real
end

@path_cache = {}
def path(course, a, b)
  return @path_cache[[course, a, b]] if @path_cache.key?([course, a, b])
  checked = {}
  paths = []
  to_check = Containers::PriorityQueue.new
  to_check.push([a, [a]], -1 * md(a, b))
  until to_check.empty? do
    pos, path = to_check.pop
    next unless course.include?(pos)
    next if checked[pos] && checked[pos] < path.size
    checked[pos] = path.size
    if pos == b
      paths.push(path)
    else
      DIRS.each do |dir|
        npos = pos + dir
        to_check.push([npos, path + [npos]], -1 * md(npos, b))
      end
    end
  end

  @path_cache[[course, a, b]] ||= paths
end

def path_to_touchpad(path)
  (1...path.size).map do |i|
    DIR_TO_TOUCHPAD[path[i] - path[i - 1]]
  end.join("")
end

@all_paths_cache = {}
def all_paths(steps)
  return steps if steps.size == 0
  return @all_paths_cache[steps] if @all_paths_cache[steps]
  rv = []
  head = steps[0]
  head.each do |n|
    ap = all_paths(steps[1..-1])
    if ap.size == 0
      rv.push([n])
    else
      ap.each do |app|
        rv.push([n] + app)
      end
    end
  end
  @all_paths_cache[steps] = rv
end

@numpad_path = {}
def numpad_path(line)
  return @numpad_path[line] if @numpad_path[line]
  c = ("A" + line.strip).chars
  all_possible = (1...c.size).map do |n|
    path(NUMPAD, R_NUMPAD[c[n-1]], R_NUMPAD[c[n]]).map {|n| path_to_touchpad(n)}
  end
  @numpad_path[line] = all_paths(all_possible).map {|n| n.join("A") + "A"}
end

@touchpad_path = {}
def touchpad_path(line)
  return @touchpad_path[line] if @touchpad_path[line]
  c = ("A" + line).chars
  all_possible = (1...c.size).map do |n|
    path(TOUCHPAD, R_TOUCHPAD[c[n-1]], R_TOUCHPAD[c[n]]).map {|n| path_to_touchpad(n)}
  end
  @touchpad_path[line] = all_paths(all_possible).map {|n| n.join("A") + "A"}
end

def part1(data, iters = 2)
  data_lines = data.lines
  numpad_lines = data_lines.map do |line|
    numpad_path(line)
  end
  touchpad_lines = numpad_lines
  iters.times do 
    touchpad_lines = touchpad_lines.map do |lines|
      paths = lines.map do |line|
        touchpad_path(line)
      end.flatten

      min = paths.map(&:size).min
      rv = paths.select {|p| p.size == min}
      rv
    end
  end
  sizes = touchpad_lines.map do |paths|
    paths.map(&:size).min
  end
  rv = 0
  sizes.each_with_index do |s, idx|
    rv += s * data_lines[idx].scan(/\d/).join.to_i
  end
  rv
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part1(REAL_DATA, 25)

