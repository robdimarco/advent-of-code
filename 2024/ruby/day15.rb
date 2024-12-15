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
TEST_DATA_3 = <<~DATA
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
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
  if map[npos].nil?
    map[pos] = nil
    return npos 
  end
  # see if can move
  loop do 
    return pos if map[npos] == "#"
    break if map[npos].nil?
    npos = npos + dir
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
    if map[k] == "O"
      (100 * k.real) + k.imag
    else
      0
    end
  end.sum
end

def parse_part2(data)
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
      l.chars.each_with_index do |v, cc|
        c = 2*cc
        if v == "#"
          map[Complex(r, c)] = v 
          map[Complex(r, c+1)] = v 
        elsif v == "O"
          map[Complex(r, c)] = "["
          map[Complex(r, c+1)] = "]" 
        elsif v == "@"
          pos = Complex(r, c)
        end
      end          
    end
  end
  [pos, map, route]
end

def move_2(spos, map, dir)
  # Given a start position, a map, and a directory.
  # We look to tne next position. 
  # If it is empty, then it is a valid move
  # If it is a wall, then it is not a valid move.
  # If it is a box, we need to see if we can move the box
  # If we are moving horizontally, we need to find the first 
  #    gap between the start position and the wall.
  #    If gap exists, not a valid move
  #    If a gap does exist, each box much move one step in the direction
  # If we are moving vertically, we need to find the first
  #    gap between all boxes supported and a wall.
  #    We need to find the line that defines the boxes
  #    If there are ANY walls in the way of a move of the line
  #       it is not a valid move
  #    IF there are ALL gaps in the way of a move in the line
  #       it is a valid move
  #       all boxes must move one step in the dir
  #    If there is a box in the way of the move
  #       We need to redefine the line to be the length of all boxes above
  dir = MOVE[dir]
  npos = spos + dir
  return npos if map[npos].nil?
  return spos if map[npos] == "#"

  moves = {}
  if dir.real == 0 # horizontal move
    bpos = npos + dir
    loop do 
      return spos if map[bpos] == "#"
      moves[bpos] = map[bpos - dir]
      moves[bpos - dir] = nil unless moves.key?(bpos - dir)
      break if map[bpos].nil?
      bpos += dir
    end
  else
    line = [npos, map[npos] == "[" ? (npos + 1i) : (npos - 1i)]
    loop do
      line.each do |bpos| 
        moves[dir + bpos] = map[bpos]
        moves[bpos] = nil unless moves.key?(bpos)
      end
      nvals = line.map {|bpos| map[bpos + dir]}.uniq.compact
      break if nvals.empty?
      return spos if nvals.include?("#")
      nline = []
      line.each do |bpos|
        nbpos = bpos + dir
        if map[nbpos]
          nline.push(nbpos)
          nline.push(map[nbpos] == "[" ? nbpos + 1i : nbpos - 1i)
        end
      end
      line = nline
    end
  end
  moves.each do |(bpos, v)|
    map[bpos] = v
  end
  spos + dir
end

def part2(data)
  pos, map, dirs = parse_part2(data)
  # dirs=dirs[0..7]
  dirs.each do |dir|
    pos = move_2(pos, map, dir)
    # printmap(pos, map)
    # puts
  end
  # printmap(pos, map)
  # puts
  map.keys.map do |k|
    if map[k] == "["
      (100 * k.real) + k.imag
    else
      0
    end
  end.sum
end
# puts part1(TEST_DATA_2)
# puts part1(TEST_DATA)
# puts part1(REAL_DATA)

puts part2(TEST_DATA_3)
puts part2(TEST_DATA)
puts part2(REAL_DATA)
