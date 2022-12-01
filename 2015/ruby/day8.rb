def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day8.txt')

def char_count(str)
  decoded_string = str
    .gsub(/\\x[a-f\d]{2}/, '.')
    .gsub(/\\\"/, '"')
    .gsub('\\\\', '\\')
  encoded_string = str
    .gsub(/\\/, '\\\\\\')
    .gsub('"', '\\"')
  # puts [str, encoded_string].join(' -> ')
  [str.length, decoded_string.length - 2, encoded_string.length + 2]
end

def answer_part_one(data)
  data = data.lines.map(&:strip)
  rv = data.reduce([0, 0]) do |acc, line|
    cnts = char_count(line)
    # puts cnts.inspect
    [acc[0] + cnts[0], acc[1] + cnts[1]]
  end
  # puts rv

  rv[0] - rv[1]
end

def answer_part_two(data)
  data = data.lines.map(&:strip)
  rv = data.reduce([0, 0]) do |acc, line|
    cnts = char_count(line)
    # puts cnts.inspect
    [acc[0] + cnts[2], acc[1] + cnts[0]]
  end
  # puts rv

  rv[0] - rv[1]
end

# assert_equal([2, 0, 6], char_count("\"\""))
# assert_equal([5, 3, 9], char_count("\"abc\""))
assert_equal([10, 7, 16], char_count("\"aaa\\\"aaa\""))
assert_equal([6, 1, 11], char_count("\"\\x27\""))
assert_equal([27, 21, 34], char_count("\"qludrkkvljljd\\\\xvdeum\\x4e\""))

sample = <<~TXT
""
"abc"
"aaa\\"aaa"
"\\x27"
TXT
assert_equal(12, answer_part_one(sample))
puts "Part 1 #{answer_part_one(data)}"
puts "Part 2 #{answer_part_two(data)}"