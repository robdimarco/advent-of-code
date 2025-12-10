
TEST_DATA =<<~DATA
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
DATA
REAL_DATA = File.read('day10.txt')

Row = Struct.new(:pattern, :buttons, :joltage)

def press(state, button)
  rv = ""
  state.chars.each_with_index do |c, idx| 
    if button.include?(idx)
      rv << (c == '#' ? '.' : '#')
    else
      rv << c
    end
  end
  rv
end

def parse(data)
 data.lines.map do |line|
   row = Row.new
   parts = line.split(" ")
   row.pattern = parts[0].tr('[]', '')
    row.buttons = parts[1..-2].map { |b| b.tr('()', '').split(',').map(&:to_i) }
    row.joltage = parts[-1].tr('{}', '').split(',').map(&:to_i)
   row
 end
end

def min_presses(row)
  states = [(['.'] * row.pattern.size).join]
  cnt = 0
  loop do
    cnt += 1
    new_states = []
    states.each do |state|
      row.buttons.each do |button|
        new_state = press(state, button)
        return cnt if new_state == row.pattern
        new_states.push(new_state) unless new_states.include?(new_state)
      end
    end
    states = new_states
  end
end

def part1(data)
  rows = parse(data)
  # puts rows.inspect
  rows.map { |r| min_presses(r)}.sum
end

def part2(data)
end

puts "Part 1"
puts part1(TEST_DATA)
puts part1(REAL_DATA) 

puts "Part 2"
puts part2(TEST_DATA)
puts part2(REAL_DATA) 
