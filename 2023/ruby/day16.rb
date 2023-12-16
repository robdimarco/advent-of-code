sample=<<~TXT.lines.map(&:strip).map(&:chars)
.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
TXT

real = File.open("day16.txt").read.lines.map(&:strip).map(&:chars)
require 'set'

def apply(data, pos, dir)
  row, col = pos
  s = data[row][col]
  rv = []

  next_space = -> (r, c, d){
    case d
    when :up
      [r - 1, c]
    when :down
      [r + 1, c]
    when :left
      [r, c - 1]
    when :right
      [r, c + 1]
    end
  }

  push_if_valid = ->(r, c,d) { 
    rv.push([[r, c], d]) if (0...data.size).include?(r) && (0...data[r].size).include?(c)
  }
  case s
  when '.'
    push_if_valid.call(*next_space.call(row, col, dir), dir)
  when '|'
    if %i(left right).include?(dir)
      push_if_valid.call(*next_space.call(row, col, :down), :down)
      push_if_valid.call(*next_space.call(row, col, :up), :up)
    else
      push_if_valid.call(*next_space.call(row, col, dir), dir)
    end
  when '-'
    if %i(up down).include?(dir)
      push_if_valid.call(*next_space.call(row, col, :left), :left)
      push_if_valid.call(*next_space.call(row, col, :right), :right)
    else
      push_if_valid.call(*next_space.call(row, col, dir), dir)
    end
  when '/'
    case dir
    when :left
      push_if_valid.call(*next_space.call(row, col, :down), :down)
    when :right
      push_if_valid.call(*next_space.call(row, col, :up), :up)
    when :up
      push_if_valid.call(*next_space.call(row, col, :right), :right)
    when :down
      push_if_valid.call(*next_space.call(row, col, :left), :left)
    end
  when '\\'
    case dir
    when :left
      push_if_valid.call(*next_space.call(row, col, :up), :up)
    when :right
      push_if_valid.call(*next_space.call(row, col, :down), :down)
    when :up
      push_if_valid.call(*next_space.call(row, col, :left), :left)
    when :down
      push_if_valid.call(*next_space.call(row, col, :right), :right)
    end
  end
  # puts "Processing #{pos} #{dir} => #{rv}"

  rv
end

def part1(data)
  # puts data.map(&:join).join("\n")
  beams = [[[0,0], :right]]
  electified = Set.new()
  i = 0
  until beams.empty? do
    i += 1
    # break if i > 1000
    pos, dir = beams.shift
    electified.add([pos, dir])
    apply(data, pos, dir).each do |(npos, ndir)|
      beams.push([npos, ndir]) unless electified.include?([npos, ndir])
    end
  end
  electified.map{|a,_| a}.uniq.size
end

def part2(lines) 
end

puts part1(sample)
puts part1(real)

# puts part2(sample)
# puts part2(real)

