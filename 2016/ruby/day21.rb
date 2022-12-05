def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day21.txt')
SAMPLE = <<~TEXT
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
TEXT

def swap_position(str, a, b)
  rv = str.dup
  rv[a] = str[b]
  rv[b] = str[a]
  rv
end

assert_equal('ebcda', swap_position('abcde', 4, 0))

def swap_letter(str, a, b)
  str.chars.map do |c|
    if c == a
      b
    elsif c == b
      a
    else
      c
    end
  end.join
end
assert_equal('edcba', swap_letter('ebcda', 'b', 'd'))

def reverse(str, start, to)
  str[0...start] + str[start..to].reverse + str[(to + 1)..-1]
end
assert_equal('abcde', reverse('edcba', 0, 4))

def rotate(str, dir, steps)
  inc = dir == :left ? 1 : -1
  (0...str.size).map do |n|
    idx = (str.size + (inc * steps) + n) % str.size
    str[idx]
  end.join
end
assert_equal('bcdea', rotate('abcde', :left, 1))
assert_equal('eabcd', rotate('abcde', :right, 1))
assert_equal('abcde', rotate('abcde', :right, 5))
assert_equal('eabcd', rotate('abcde', :right, 11))

def rotate_based_on_position(str, char)
  steps = str.index(char)
  steps += 1 if steps >= 4
  steps += 1
  rotate(str, :right, steps)
end
assert_equal('ecabd', rotate_based_on_position('abdec', 'b'))
assert_equal('decab', rotate_based_on_position('ecabd', 'd'))

def move(str, from, to)
  c = str[from]
  (str[0...from] + str[(from + 1)..-1]).insert(to, c)
end

assert_equal('bdeac', move('bcdea', 1, 4))
assert_equal('abdec', move('bdeac', 3, 0))

def parse_line(line)
  tokens = line.split(' ')
  case tokens[0]
  when 'swap'
    case tokens[1]
    when 'position'
      [:swap_position, tokens[2].to_i, tokens[5].to_i]
    when 'letter'
      [:swap_letter, tokens[2], tokens[5]]
    end
  when 'reverse'
    [:reverse, tokens[2].to_i, tokens[4].to_i]
  when 'rotate'
    case tokens[1]
    when 'based'
      [:rotate_based_on_position, tokens[6]]
    else
      [:rotate, tokens[1].to_sym, tokens[2].to_i]
    end
  when 'move'
    [:move, tokens[2].to_i, tokens[5].to_i]
  end
end

def scrambled(password, instructions)
  instructions = instructions.lines.map {|l| parse_line(l)}
  instructions.each do |i|
    password = send(i[0], password, *i[1..-1])
  end
  password
end

assert_equal('decab', scrambled('abcde', SAMPLE))
puts "Part 1: #{scrambled('abcdefgh', DATA)}"