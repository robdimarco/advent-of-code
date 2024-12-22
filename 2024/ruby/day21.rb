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

@path_cache = {}
def path(course, a, b)
  return @path_cache[[a, b]] if @path_cache.key?([a, b]) && course == TOUCHPAD
  d_col = a.imag - b.imag == 0 ? 0 : (b.imag - a.imag) / (a.imag - b.imag).abs
  d_row = a.real - b.real == 0 ? 0 : (b.real - a.real) / (a.real - b.real).abs
  path = [a]
  pos = a
  strategy = :left_vert_right
  strategy = :vert_horiz if b.imag == 0 && !course[Complex(a.real, 0)]
  strategy = :horiz_vert if d_row != 0 && a.imag == 0 && !course[Complex(b.real, 0)]

  if strategy == :left_vert_right
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
  path.each {|p| raise "Doh... invalid #{pos}" unless course[p]}
  @path_cache[[a, b]] = path if  course == TOUCHPAD
  path
end

def path_to_touchpad(path)
  (1...path.size).map do |i|
    DIR_TO_TOUCHPAD[path[i] - path[i - 1]]
  end.join("")
end

def numpad_path(line)
  pad = NUMPAD
  rpad = R_NUMPAD

  c = ("A" + line).chars
  rv = []
  (1...c.size).map do |n|
    npath = path_to_touchpad(path(pad, rpad[c[n-1]], rpad[c[n]]))+ "A"
    rv.push(npath)
  end
  rv
end

@size_at_level_cache = {}
def size_at_level(line, level)
  if level == 0
    return line.size 
  end

  cache_key = [line, level]
  return @size_at_level_cache[cache_key] if @size_at_level_cache.key?(cache_key)

  chars = ("A"+line).chars
  steps = (1...chars.size).map do |n|
    [chars[n-1], chars[n]]
  end
  next_level_steps = steps.map do |(a, b)|
    path_to_touchpad(path(TOUCHPAD, R_TOUCHPAD[a], R_TOUCHPAD[b])) + "A"
  end
  rv = next_level_steps.map do |step|
    size_at_level(step, level - 1)
  end.sum

  @size_at_level_cache[cache_key] = rv
end

def part1(data, iters = 2)
  data_lines = data.lines
  numpad_lines = data_lines.map do |line|
    numpad_path(line.strip).join
  end
  sizes = numpad_lines.map {|l| size_at_level(l, iters)}
  rv = 0
  sizes.each_with_index do |s, idx|
    rv += s * data_lines[idx].scan(/\d/).join.to_i
  end
  rv
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part1(REAL_DATA, 25)

