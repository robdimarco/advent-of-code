def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day1.txt')
ORIENTATIONS = [[1,0], [0,1], [-1, 0], [0, -1]]
def move(data)
  stops = []
  oidx = 0
  position = [0, 0]
  data.split(', ').each do |cmd|
    direction = cmd[0]
    rest = cmd[1..-1].to_i
    if direction == 'R'
      # puts "move right"
      oidx = oidx == ORIENTATIONS.size - 1 ? 0 : oidx + 1
    else
      # puts "move left"
      oidx = oidx == 0 ? ORIENTATIONS.size - 1 : oidx - 1
    end

    rest.times do 
      position = [position[0] + (ORIENTATIONS[oidx][0]), position[1] + (ORIENTATIONS[oidx][1])]
      if stops.include?(position)
        puts "Stop: #{position.inspect} #{position.map(&:abs).sum}"
      end
      stops.push(position)
      
    end
    # puts "At #{cmd} moved to #{position.inspect} at orientation #{ORIENTATIONS[oidx].inspect}"
  end
  position.map(&:abs).sum
end
# assert_equal(5, move('R2, L3'))
# assert_equal(2, move('R2, R2, R2'))
# assert_equal(12, move('R5, L5, R5, R3'))
# assert_equal(8, move('R8, R4, R4, R8'))
puts "Part1: #{move(data)}"