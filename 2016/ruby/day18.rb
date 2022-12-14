def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day18.txt').strip

TRAP_GENS = ['^^.', '.^^', '^..', '..^']

def safe_tiles(row_string, total)
  row = row_string.chars
  rows = [row]
  # row_hash = {}
  while rows.size < total do
    lrow = rows[-1]
    nrow = (0...lrow.size).map do |n|
      left = n > 0 ? lrow[n - 1] : '.'
      center = lrow[n]
      right = lrow[n + 1] || '.'

      TRAP_GENS.include?([left, center, right].join) ? '^' : '.'
    end

    puts "Row count #{rows.size}" if rand(1000) == 0

    # if row_hash.key?(nrow)
    #   puts "Got match"
    #   for_pattern = rows.flatten.join.chars.count {|c| c == '.'}
    #   extra_lines = total % for_pattern.size

    #   extra_vals = rows[0...extra_lines].flatten.join.chars.count {|c| c == '.'}

    #   return for_pattern * total / for_pattern.size + extra_vals
    # end

    rows.push(nrow)
  end
  rows.map {|row| row.count {|c| c == '.'}}.sum
end

assert_equal(6, safe_tiles('..^^.', 3))
assert_equal(38, safe_tiles('.^^.^.^^^^', 10))

puts "Part 1: #{safe_tiles(data, 40)}"
puts "Part 2: #{safe_tiles(data, 400000)}"
