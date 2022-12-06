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
assert_equal('abcde', swap_position('ebcda', 0, 4))

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
assert_equal('ebcda', swap_letter('edcba', 'b', 'd'))

def reverse(str, start, to)
  str[0...start] + str[start..to].reverse + str[(to + 1)..-1]
end
assert_equal('abcde', reverse('edcba', 0, 4))
assert_equal('edcba', reverse('abcde', 0, 4))

def rotate(str, dir, steps)
  inc = dir == :left ? 1 : -1
  (0...str.size).map do |n|
    idx = (str.size + (inc * steps) + n) % str.size
    str[idx]
  end.join
end
assert_equal('bcdea', rotate('abcde', :left, 1))
assert_equal('abcde', rotate('bcdea', :right, 1))
assert_equal('eabcd', rotate('abcde', :right, 1))
assert_equal('abcde', rotate('eabcd', :left, 1))
assert_equal('abcde', rotate('abcde', :right, 5))
assert_equal('eabcd', rotate('abcde', :right, 11))

def rotate_based_on_position(str, char, dir=:right)
  # require 'debug'; binding.break
  if dir == :right
    steps = str.index(char)
    steps += 1 if dir == :right && steps >= 4
    steps += 1
    rotate(str, dir, steps)
  else
    rv = nil
    i = 1
    while rv.nil?
      t = rotate(str, :left, i)
      rv = t if rotate_based_on_position(t, char) == str
      i += 1
    end
    rv
  end
end
assert_equal('ecabd', rotate_based_on_position('abdec', 'b'))
assert_equal('abdec', rotate_based_on_position('ecabd', 'b', :left))
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

def unscrambled(password, instructions)
  instructions = instructions.lines.map {|l| parse_line(l)}
  instructions.reverse.each do |i|
    cmd = i[0]
    args = i[1..-1]
    case cmd
    when :swap_position, :swap_letter, :reverse
      # no op
    when :rotate_based_on_position
      args << :left
    when :rotate
      args[0] = args[0] == :left ? :right : :left
    when :move
      args = args.reverse
    end
    password = send(cmd, password, *args)
  end
  password  
end

assert_equal('abcde', unscrambled('decab', SAMPLE))
assert_equal('abcdefgh', unscrambled(scrambled('abcdefgh', DATA), DATA))
puts "Part2: #{unscrambled('fbgdceah', DATA)}"