def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day2.txt')

sample = <<~TEXT
ULL
RRDDD
LURDL
UUUUD
TEXT

PAD = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
PAD_2 = [
  [nil, nil, 1, nil, nil],
  [nil,   2, 3,   4, nil],
  [5,     6, 7,   8,   9],
  [nil, 'A','B','C', nil],
  [nil, nil,'D',nil, nil],
]
def code(data, pad, pos)
  data.lines.map do |line|
    line.strip!.chars.each do |c|
      case c
      when 'U'
        if pos[0] > 0 && pad[pos[0] - 1] && pad[pos[0] - 1][pos[1]]
          pos[0] -= 1 
        end
      when 'L'
        if pos[1] > 0 && pad[pos[0]][pos[1] - 1]
          pos[1] -= 1
        end
      when 'R'
        if pad[pos[0]][pos[1] + 1]
          pos[1] += 1
        end
      when 'D'
        if pad[pos[0] + 1] && pad[pos[0] + 1][pos[1]]
          pos[0] += 1
        end
      end
      # puts pos.inspect
    end
    # puts pad[pos[0]][pos[1]]

    pad[pos[0]][pos[1]]

  end.join
end

# assert_equal('1985', code(sample, PAD, [1,1]))
# puts "Part 1: #{code(data, PAD, [1,1])}"
assert_equal('5DB3', code(sample, PAD_2, [2,0]))
puts "Part 2: #{code(data, PAD_2, [2,2])}"

