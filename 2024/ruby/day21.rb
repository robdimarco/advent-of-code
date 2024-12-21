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

def path(course, a, b)
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
  paths
end

def path_to_touchpad(path)
  (1...path.size).map do |i|
    DIR_TO_TOUCHPAD[path[i] - path[i - 1]]
  end.join("")
end

# [["<"], ["^"], ["^^>", "^>^", ">^^"], ["vvv"]]
# [] => []
# [["vvv"], ["abc"]] => [["vvv"], ["abc"]]
# [["^^>", "^>^", ">^^"], ["vvv", "abc"]] => [["^^>", "vvv"], ["^>^", "vvv"], [">^^", "vvv"]]
# [[">"], ["^^>", "^>^", ">^^"], ["vvv"]] => [[">", "^^>", "vvv"], [">", "^>^", "vvv"], [">", ">^^", "vvv"]]

def all_paths(steps)
  return steps if steps.size == 0
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
  rv
end

def part1(data)
  data_lines = data.lines
  numpad_lines = data_lines.map do |line|
    c = ("A" + line.strip).chars
    all_possible = (1...c.size).map do |n|
      path(NUMPAD, R_NUMPAD[c[n-1]], R_NUMPAD[c[n]]).map {|n| path_to_touchpad(n)}
    end
    aa = all_paths(all_possible).map {|n| n.join("A") + "A"}
    aa
  end
  # puts "#{numpad_lines}"
  touchpad_lines = numpad_lines.map do |lines|
    paths = lines.map do |line|
      c = ("A" + line).chars
      # puts c.inspect
      all_possible = (1...c.size).map do |n|
        path(TOUCHPAD, R_TOUCHPAD[c[n-1]], R_TOUCHPAD[c[n]]).map {|n| path_to_touchpad(n)}
      end
      aa = all_paths(all_possible).map {|n| n.join("A") + "A"}
      aa
    end.flatten
    # puts paths.inspect
    min = paths.map(&:size).min
    paths.select {|p| p.size == min}
  end
  # puts touchpad_lines.inspect
  sizes = touchpad_lines.map do |lines|
    paths = lines.map do |line|
      c = ("A" + line).chars
      # puts c.inspect
      all_possible = (1...c.size).map do |n|
        path(TOUCHPAD, R_TOUCHPAD[c[n-1]], R_TOUCHPAD[c[n]]).map {|n| path_to_touchpad(n)}
      end
      aa = all_paths(all_possible).map {|n| n.join("A") + "A"}
      aa
    end.flatten
    # puts paths.inspect
    paths.map(&:size).min
  end
  rv = 0
  sizes.each_with_index do |s, idx|
    rv += s * data_lines[idx].scan(/\d/).join.to_i
  end
  rv
  # puts touchpad_lines
  # touchpad_lines = touchpad_lines.map do |line|
  #   c = ("A" + line).chars
  #   (1...c.size).map do |n|
  #     path_to_touchpad(path(TOUCHPAD, R_TOUCHPAD[c[n-1]], R_TOUCHPAD[c[n]]))
  #   end.join("A") + "A"
  # end
  # touchpad_lines.map(&:size)
end
puts part1(TEST_DATA)
puts part1(REAL_DATA)

def part2(data)
end
