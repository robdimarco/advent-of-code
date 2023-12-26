sample=<<~TXT.lines
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
TXT
real = File.open("day22.txt").read.lines

Pos = Struct.new(:x, :y, :z) do 
  def export
    [x, y, z].join(",")
  end
end
Brick = Struct.new(:label, :p1, :p2) do
  def x_y_support?(b)
    (x_range.include?(b.p1.x) || x_range.include?(b.p2.x) || b.x_range.include?(p1.x) || b.x_range.include?(p2.x)) && 
      (y_range.include?(b.p1.y) || y_range.include?(b.p2.y) || b.y_range.include?(p1.y) || b.y_range.include?(p2.y))
  end
  def supports?(b)
    [b.p1.z, b.p2.z].min == [p1.z, p2.z].max + 1 && x_y_support?(b)
  end

  def ground?
    p1.z == 1 || p2.z == 1    
  end

  def x_range
    (p1.x..p2.x)
  end

  def y_range
    (p1.y..p2.y)
  end
  def export
    [p1.export, p2.export].join("~")
  end
end

def drop(bricks_by_x_y)
  bricks_by_x_y.each do |(brick, bricks)|
    next if brick.ground?
    # puts "#{brick.label} has #{bricks.size}"
    sb = bricks.detect {|bb| bb != brick && bb.supports?(brick)}
    if sb.nil?
      brick.p1.z -= 1
      brick.p2.z -= 1
      return brick
    end
  end
  nil
end
# puts Brick.new('A', Pos.new(1, 0, 1), Pos.new(1, 2, 1)).supports?(
#   Brick.new('B', Pos.new(0, 0, 2), Pos.new(2, 0, 2))
# )
# puts Brick.new(Pos.new(1, 0, 1), Pos.new(1, 2, 1)).supports?(
#   Brick.new(Pos.new(0, 2, 3), Pos.new(2, 2, 3))
# )
# puts Brick.new(Pos.new(0, 0, 2), Pos.new(2, 0, 2)).supports?(
#   Brick.new(Pos.new(1, 0, 1), Pos.new(1, 2, 1))
# )

def to_l(i)
  rv = ""
  loop do 
    rv += ('A'.ord + (i % 26)).chr
    i /= 26
    return rv if i == 0
  end
end

def parse(lines)
  bricks = []
  lines.each_with_index do |l, i|
    a, b = l.strip.split("~")
    bricks.push(Brick.new(to_l(i), Pos.new(*a.split(',').map(&:to_i)), Pos.new(*b.split(',').map(&:to_i))))
  end
  bricks
end
require 'pp'

def run(bricks)
  bricks_by_x_y = Hash.new {|h,k| h[k] = []}
  
  bricks.each do |brick|
    bricks.each do |bb|
      bricks_by_x_y[brick].push(bb) if brick.x_y_support?(bb)
    end
  end

  loop do
    b = drop(bricks_by_x_y)
    break if b.nil?
    puts ".. Dropping #{b}" if b.label == "XC"
  end
end

def support_graph(bricks)
  supported_by = Hash.new { |h, k| h[k] = []}
  supports = Hash.new { |h, k| h[k] = []}

  bricks.each do |b|
    bricks.each do |bb| 
      if bb != b && b.supports?(bb)
        supports[b].push(bb)
        supported_by[bb].push(b)
      end
    end
  end
  [supported_by, supports]
end


def part1(data)
  bricks = parse(data)
  run(bricks)
  supported_by, supports = support_graph(bricks)

  cnt = 0
  bricks.each do |b|
    
    # puts "Looking at Brick #{b.label}"
    supported_only_by_me = supports[b].detect do |bb|
      supported_by[bb].size == 1
    end
    cnt += 1 unless supported_only_by_me
  end
  cnt
end

def disintegrations_from_brick(b, supports, supported_by)
  # For every brick I support
  bricks = Set.new
  bricks.add(b)

  to_check = []
  supports[b].each do |bb|
    # puts "  only support..."
    to_check.push([bb, b])
  end

  until to_check.empty? do
    top, bottom = to_check.shift
    # puts "Checking #{top.label} above #{bottom.label}"
    if supported_by[top].all? { |q| bricks.include?(q) }
      # puts "  #{top.label} has no support"
      bricks.add(top)
      supports[top].each {|q| to_check.push([q, top])}
    end
  end

  bricks.size - 1
  #   If I am the only brick that supports it
  #   Then I need to know the number of bricks it supports up the tre
end

require 'set'
def part2(data, export=false)
  bricks = export && File.file?(export) ? parse(File.open(export).read.lines) : parse(data)
  run(bricks)
  if export
    File.open(export, "w") do |o|
      o.write(bricks.map(&:export).join("\n"))
    end
  end
  supported_by, supports = support_graph(bricks)

  bricks.sort_by(&:label).map do |b|
    disintegrations_from_brick(b, supports, supported_by)
  end.sum

end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real, "day22-part2.txt")