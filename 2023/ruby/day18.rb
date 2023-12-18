sample=<<~TXT.lines.map(&:strip)
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
TXT

real = File.open("day18.txt").read.lines.map(&:strip)

Instruction = Struct.new(:dir, :length, :color)
DirMap = {
  'D' => [1, 0],
  'U' => [-1, 0],
  'L' => [0, -1],
  'R' => [0, 1]
}
def parse(data)
  data.map do |line|
    d, l, c = line.split(' ')
    Instruction.new(d, l.to_i, c.delete('(').delete(')'))
  end
end

def graph(instructions)
  pos = [0, 0]
  rv = {}
  instructions.each do |ins|
    dr, dc = DirMap[ins.dir]
    ins.length.times do |i|
      pos = [pos[0] + dr, pos[1] + dc]
      rv[pos] = ins.color
    end
  end
  rv
end

def part1(data)
  inst = parse(data)
  g = graph(inst)
  rows = g.keys.map { |k| k[0]}
  cols = g.keys.map { |k| k[1]}

  min_r = rows.min
  min_c = cols.min

  rows = rows.max - rows.min + 1
  cols = cols.max - cols.min + 1

  cnt = 0
  graph = []
  lines = []
  inside = false
  rows.times do |r|
    graph.push([])
    lines.push([])
    boundary = 0
    cols.times do |c|
      in_g = !!g[[r + min_r, c + min_c]]
      if in_g
        lines[-1].push("#")
        graph[-1].push("#")
        if r > min_r
          # Has one above
          if g[[r + min_r - 1, c + min_c]]
            if g[[r + min_r + 1, c + min_c]]
              boundary += 1
            elsif c > min_c && g[[r + min_r, c + min_c - 1]]
              boundary += 1
            elsif g[[r + min_r, c + min_c + 1]]
              boundary += 1
            end
          end
        end
        cnt += 1
      else
        lines[-1].push(".")
        if boundary % 2 == 1
          graph[-1].push("#")
          cnt += 1
        else
          graph[-1].push(".")
        end
      end
    end
  end

  # puts lines.map(&:join).join("\n")
  # puts
  # puts
  # puts graph.map(&:join).join("\n")
  cnt
end

def part2(data)
end

puts part1(sample)
puts part1(real)

# puts part2(sample)
# puts part2(real)