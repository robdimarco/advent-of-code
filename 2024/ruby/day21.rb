TEST_DATA = <<~DATA
029A
980A
179A
456A
379A
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
require 'algorithms'
require 'debug'
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

@path_cache = {
  # Hard code some efficient paths
  [TOUCHPAD, 1+0i, 2i] => [[(1+0i), (1+1i), (1+2i), (0+2i)]], 
  [TOUCHPAD, 2i, 1+0i] => [[(0+2i), (1+2i), (1+1i), (1+0i)]], 
  [TOUCHPAD, 2i, 1+1i] => [[(0+2i), (0+1i), (1+1i)]], 
  [TOUCHPAD, 1+2i, 0+1i] => [[(1+2i), (1+1i), (0+1i)]], 
  [TOUCHPAD, 1+1i, 2i] => [[(1+1i), (0+1i), (0+2i)]], 
}
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

def numpad_path(line)
  find_path(line, NUMPAD, R_NUMPAD)
end

def touchpad_path(line)
  find_path(line, TOUCHPAD, R_TOUCHPAD)
end
Branch = Struct.new(:lines)

@find_path_cache = {}
def find_path(line, pad, rpad)
  return @find_path_cache[line] if @find_path_cache[line]
  if line.is_a?(String)
    print 's'
    c = ("A" + line).chars
    rv = []
    (1...c.size).map do |n|
      paths = path(pad, rpad[c[n-1]], rpad[c[n]]).map {|n| path_to_touchpad(n) + "A"}
      rv.push(paths[0]) if paths.size == 1
      if paths.size > 1
        h = Hash.new {|h,k| h[k] = []}
        paths.each {|path| h[path.size].push(path)}
        hmin = h.keys.min
        paths = h[hmin]

        h = Hash.new {|h,k| h[k] = []}
        paths.each do |path| 
          mcnt = 0
          (1...path.size).each do |n|
            mcnt += 1 if path.chars[n] == path.chars[n-1]
          end
          h[mcnt].push(path)
        end
        hmin = h.keys.max
        paths = h[hmin]

        rv.push(Branch.new(paths))
      end
    end
    @find_path_cache[line] = rv
  elsif line.is_a?(Branch)
    print 'b'
    @find_path_cache[line] ||= Branch.new(line.lines.map {|l| find_path(l, pad, rpad)})
  elsif line.is_a?(Array)
    print 'a'
    @find_path_cache[line] ||= line.map {|l| find_path(l, pad, rpad)}.flatten
  else
    raise "Doh #{line}"
  end
end
def linesize(line)
  return line.size if line.is_a?(String)
  return line.lines.map {|l| linesize(l)}.min if line.is_a?(Branch)
  return line.map {|l| linesize(l)}.sum if line.is_a?(Array)
  raise "Doh #{line}"
end

def part1(data, iters = 2)
  data_lines = data.lines
  numpad_lines = data_lines.map do |line|
    numpad_path(line.strip)
  end
  touchpad_lines = numpad_lines
  iters.times do |idx|
    touchpad_lines = touchpad_lines.map do |lines|
      touchpad_path(lines)
    end
    puts "#{idx}: #{touchpad_lines.map {|l| linesize(l)}.inspect} #{@find_path_cache.size}"
  end

  sizes = touchpad_lines.map do |paths|
    linesize(paths)
  end
  rv = 0
  sizes.each_with_index do |s, idx|
    rv += s * data_lines[idx].scan(/\d/).join.to_i
  end
  rv
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
# binding.break
puts part1(REAL_DATA, 26)

