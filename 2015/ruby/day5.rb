def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day5.txt').lines.map(&:strip)

def naughty_or_nice_part_1(str)
  naughty = %w(ab cd pq xy)
  doubles = ('a'..'z').map {|c| [c,c].join }
  
  naughty_pattern = naughty.any? {|s| str.include?(s)}
  vowel_pattern = str.chars.count {|c| %w(a e i o u).include?(c)} > 2
  double_pattern = doubles.any? {|s| str.include?(s)}
  # puts "naughty_pattern: #{naughty_pattern} vowel_pattern: #{vowel_pattern} double_pattern: #{double_pattern}"
  if !naughty_pattern && vowel_pattern && double_pattern
    :nice
  else
    :naughty
  end
end
puts "Part 1"

assert_equal(:nice, naughty_or_nice_part_1('ugknbfddgicrmopn')) # is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
assert_equal(:nice, naughty_or_nice_part_1('aaa')) # is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
assert_equal(:naughty, naughty_or_nice_part_1('jchzalrnumimnmhp')) # is naughty because it has no double letter.
assert_equal(:naughty, naughty_or_nice_part_1('haegwjzuvuyypxyu')) # is naughty because it contains the string xy.
assert_equal(:naughty, naughty_or_nice_part_1('dvszwmarrgswjxmb')) # is naughty because it contains only one vowel.


puts data.count {|s| naughty_or_nice_part_1(s) == :nice}
puts "Part 2"
def two_letter_overlap(str)
  str.length > 2 && (str[2..-1].include?(str[0..1]) || two_letter_overlap(str[1..-1]))
end

def one_letter_gap(str)
  str.length > 2 && (str[0] == str[2] || one_letter_gap(str[1..-1]))
end

def naughty_or_nice_part_2(str)
  two_letter_overlap(str) && one_letter_gap(str) ? :nice : :naughty
end

[['qjhvhtzxzqqjkmpb', :nice], ['xxyxx', :nice], ['uurcxstgmygtbstg', :naughty], ['ieodomkazucvgmuy', :naughty]].each do |(str, exp)|
  assert_equal(exp, naughty_or_nice_part_2(str), "From #{str}")
end

puts data.count {|s| naughty_or_nice_part_2(s) == :nice}

