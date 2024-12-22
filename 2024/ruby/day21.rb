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

@path_cache = {}
def path(course, a, b)
  return @path_cache[[course, a, b]] if @path_cache.key?([course, a, b])
  d_col = a.imag - b.imag == 0 ? 0 : (b.imag - a.imag) / (a.imag - b.imag).abs
  d_row = a.real - b.real == 0 ? 0 : (b.real - a.real) / (a.real - b.real).abs
  path = [a]
  pos = a
  strategy = :left_vert_left
  strategy = :vert_horiz if b.imag == 0 && !course[Complex(a.real, 0)]
  strategy = :horiz_vert if d_row != 0 && a.imag == 0 && !course[Complex(b.real, 0)]

  if strategy == :left_vert_left
    # If left, do it
    if d_col < 0
      until pos.imag == b.imag do
        pos += Complex(0, d_col)
        path.push(pos)
      end
    end

    # Up / Down
    until pos.real == b.real do
      pos += Complex(d_row, 0)
      path.push(pos)
    end

    # Move right
    until pos.imag == b.imag do
      pos += Complex(0, d_col)
      path.push(pos)
    end
  elsif strategy == :vert_horiz

    # Up / Down
    until pos.real == b.real do
      pos += Complex(d_row, 0)
      path.push(pos)
    end

    # Move right
    until pos.imag == b.imag do
      pos += Complex(0, d_col)
      path.push(pos)
    end
  elsif strategy == :horiz_vert

    # Move horizontal
    until pos.imag == b.imag do
      pos += Complex(0, d_col)
      path.push(pos)
    end

    until pos.real == b.real do
      pos += Complex(d_row, 0)
      path.push(pos)
    end
  end
  @path_cache[[course, a, b]] = path
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

@find_path_cache = {}
def find_path(line, pad, rpad)
  return @find_path_cache[line] if @find_path_cache[line]
  if line.is_a?(String)
    # puts "checking line #{line.size}"
    c = ("A" + line).chars
    rv = []
    (1...c.size).map do |n|
      npath = path_to_touchpad(path(pad, rpad[c[n-1]], rpad[c[n]]))+ "A"
      rv.push(npath)
    end
    # puts "done checking line"
    @find_path_cache[line] = rv
  elsif line.is_a?(Array)
    # puts "checking #{line.size}"
    rv = line.map {|l| find_path(l.is_a?(Array) ? l.join : l, pad, rpad)}
    # binding.break
    @find_path_cache[line] ||= rv.flatten
  else
    raise "Doh #{line}"
  end
end
def linesize(line)
  return line.size if line.is_a?(String)
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
# puts part1(REAL_DATA, 26)
puts part1("0", 26)

