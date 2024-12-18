require 'algorithms'
TEST_DATA = <<~DATA
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
DATA
REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
def parse(data)
  data.lines.map do |line|
    Complex(*line.split(",").map(&:to_i))
  end
end
DIRS = [1, -1, 1i, -1i]

def min_path(drops, target)
  pos = 0 + 0i
  to_check = Containers::PriorityQueue.new
  DIRS.each do |dir|
    to_check.push([pos, dir, []], [0, -target.abs])
  end
  solutions = []
  visited = {Complex(0,0) => 0}
  until to_check.empty? do
    pos, dir, path = to_check.pop
    new_pos = pos + dir
    new_path = path + [new_pos]
    next if new_pos.real < 0 || new_pos.imag < 0 || new_pos.real > target.real || new_pos.imag > target.imag
    next if visited[new_pos] && new_path.size >= visited[new_pos].to_i

    # puts "#{new_path.size} #{new_pos}"
    visited[new_pos] = new_path.size
    if new_pos == target
      solutions.push(new_path)
      # puts "Found #{new_path.size}"
    elsif drops.include?(new_pos)
      next
    elsif solutions.any? && new_path.size + (new_pos.real - target.real).abs + (new_pos.imag - target.imag).abs >= solutions.map(&:size).min
      next
    else
      DIRS.each do |new_dir|
        to_check.push([new_pos, new_dir, new_path], [new_path.size, -1 * (new_pos - target).abs])
      end
    end
  end

  solutions.map(&:size).min
end

def has_path(drops, target)
  pos = 0 + 0i
  to_check = Containers::PriorityQueue.new
  DIRS.each do |dir|
    to_check.push([pos, dir, []], [0, -target.abs])
  end

  visited = {Complex(0,0) => 0}
  until to_check.empty? do
    pos, dir, path = to_check.pop
    new_pos = pos + dir
    new_path = path + [new_pos]
    next if new_pos.real < 0 || new_pos.imag < 0 || new_pos.real > target.real || new_pos.imag > target.imag
    next if visited[new_pos] && new_path.size >= visited[new_pos].to_i

    # puts "#{new_path.size} #{new_pos}"
    visited[new_pos] = new_path.size
    if new_pos == target
      return new_path
    elsif drops.include?(new_pos)
      next
    else
      DIRS.each do |new_dir|
        to_check.push([new_pos, new_dir, new_path], [new_path.size, -1 * (new_pos - target).abs])
      end
    end
  end

  nil
end

def part1(data, time, target)
  drops = parse(data)
  min_path(drops[0...time], target)
end

def part2(data, target)
  drops = parse(data)
  i = drops.size - 1
  current_path = nil
  loop do 
    raise "doh" if i < 0
    current_path = has_path(drops[0..i], target)

    return drops[i+1] unless current_path.nil?

    i -= 1
  end
end

# puts part1(TEST_DATA, 12, 6+6i)
# puts part1(REAL_DATA, 1024, 70+70i)
puts part2(TEST_DATA, 6+6i)
puts part2(REAL_DATA, 70+70i)
