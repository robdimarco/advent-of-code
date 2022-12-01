def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day6.txt').lines.map(&:strip)

def apply_command(grid, cmd)
  coord_1, coord2 = cmd.scan(/\d+,\d+/).map {|coord| coord.split(',').map(&:to_i)}
  (coord_1[0]..coord2[0]).each do |x|
    (coord_1[1]..coord2[1]).each do |y|
      if cmd.start_with?('turn on')
        grid[[x, y]] = 1
      elsif cmd.start_with?('toggle')
        grid[[x, y]] = grid[[x, y]].to_i * -1 + 1
      elsif cmd.start_with?('turn off')
        grid[[x, y]] = 0
      end
    end
  end
  grid
end

def count(grid)
  grid.values.sum
end

# assert_equal(1000 * 1000, count(apply_command({}, "turn on 0,0 through 999,999")))
assert_equal(1000, count(apply_command({}, "toggle 0,0 through 999,0")))
assert_equal(0, count(apply_command({}, "turn off 499,499 through 500,500 ")))
assert_equal(1000 * 1000 - 4, 
  count(
    apply_command(
      apply_command({}, "turn on 0,0 through 999,999"), 
      "turn off 499,499 through 500,500 "
    )
  )
)

grid = {}
data.each {|l| apply_command(grid, l)}
puts count(grid)