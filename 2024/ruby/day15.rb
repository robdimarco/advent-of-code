TEST_DATA = <<~DATA
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
DATA
TEST_DATA_2 = <<~DATA
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
DATA

REAL_DATA = File.read(File.basename(__FILE__, ".rb") + ".txt")
MOVE={
  "<" => Complex(0, -1),
  "v" => Complex(1, 0),
  ">" => Complex(0, 1),
  "^" => Complex(-1, 0),
}

def parse(data)
  pos = nil
  map = {}
  route = []
  b = false  
  data.lines.each_with_index do |l, r|
    l.strip!
    if l.empty?
      b = true
    elsif b
      route += l.chars
    else
      l.chars.each_with_index do |v, c|
        map[Complex(r, c)] = v if v == "#" || v == "O"
        pos = Complex(r, c) if v == "@"
      end          
    end
  end
  [pos, map, route]
end

def printmap(pos, map)
  rr = map.keys.map(&:real).max
  cc = map.keys.map(&:imag).max
  (0..rr).each do |r|
    (0..cc).each do |c|
      n = Complex(r,c)
      if pos == n
        print "@"
      else
        print map[n] || "."
      end
    end
    puts
  end
end

def move(pos, map, dir)
  dir = MOVE[dir]
  npos = pos + dir
  return npos if map[npos] == "."
  # see if can move
  loop do 
    nnpos = npos + dir
    return pos if map[npos] == "#"
    break if map[npos].nil?
    npos = nnpos    
  end

  epos = npos
  spos = pos + dir
  map[pos] = nil
  map[spos] = nil
  npos = spos
  loop do
    map[npos] = "O"
    break if epos == npos
    npos += dir
  end
  spos
end

def part1(data)
  pos, map, dirs = parse(data)
  dirs.each do |dir|
    pos = move(pos, map, dir)
  end
  # printmap(pos, map)
  # puts
  map.keys.map do |k|
    if map[k] == "O" && k != pos
      (100 * k.real) + k.imag
    else
      0
    end
  end.sum
end

def part2(data)
end
puts part1(TEST_DATA_2)
puts part1(TEST_DATA)
puts part1(REAL_DATA)

