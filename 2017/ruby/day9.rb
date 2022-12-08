def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt'))

def parse(str)
  i = 0
  in_garbage = false
  stack = []
  rv = []
  garbage_chars = 0
  while i < str.size
    c = str[i]
    case c
    when '{'
      unless in_garbage
        stack.unshift(1)
        rv << stack.size
      else
        garbage_chars += 1
      end
    when '}'
      unless in_garbage
        stack.shift
      else
        garbage_chars += 1
      end
    when '!'
      i += 1
      # garbage_chars if in_garbage
    when '<'
      garbage_chars += 1 if in_garbage
      in_garbage = true
    when '>'
      in_garbage = false
    else
      garbage_chars += 1 if in_garbage
    end
    i += 1
  end
  [rv.sum, garbage_chars]
end

def score(input)
  parse(input)[0]
end

def garbage(input)
  parse(input)[1]
end
  
assert_equal(1, score("{}"))
assert_equal(6, score("{{{}}}"))
assert_equal(5, score("{{},{}}"))
assert_equal(16, score("{{{},{},{{}}}}"))
assert_equal(1, score("{<a>,<a>,<a>,<a>}"))
assert_equal(9, score("{{<ab>},{<ab>},{<ab>},{<ab>}}"))
assert_equal(9, score("{{<!!>},{<!!>},{<!!>},{<!!>}}"))
assert_equal(3, score("{{<a!>},{<a!>},{<a!>},{<ab>}}"))


puts "Part 1: #{score(DATA)}"
assert_equal(0, garbage("<>"))
assert_equal(17, garbage("<random characters>"))
assert_equal(3, garbage("<<<<>"))
assert_equal(2, garbage("<{!>}>"))
assert_equal(0, garbage("<!!>"))
assert_equal(0, garbage("<!!!>>"))
assert_equal(10, garbage("<{o\"i!a,<{i<a>"))
puts "Part 2: #{garbage(DATA)}"