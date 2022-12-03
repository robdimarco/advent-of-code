def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
@cache = {}

def code_book(row, col)
  return 20151125 if row == 1 && col == 1
  # puts @cache.size
  return @cache[[row, col]] if @cache.include?([row, col])

  if col == 1
    next_row = 1
    next_col = row - 1
  else
    next_row = row + 1
    next_col = col - 1
  end

    # if col = 1
    # row 1 col 3 -> row 2, col 2 -> row 3, col 1 -> row 1, col 2 -> row 2, col 1 -> row 1, col 1
  # puts "checkin #{next_row}, #{next_col}"
  v = code_book(next_row, next_col)
  v = (v * 252533) % 33554393
  @cache[[row, col]] = v
  v
  # [[],[],[],[],[], [0,0,0,0,0,0]]
end

(1..3020).each do |row|
  print '.'
  (1..row).each do |col|
    # puts [row, col].inspect
    code_book(row, col)
  end
end

assert_equal(20151125, code_book(1,1))
assert_equal(31916031, code_book(2,1))
assert_equal(18749137, code_book(1,2))
assert_equal(27995004, code_book(6,6))
puts "Part 1: #{code_book(3010, 3019)}"