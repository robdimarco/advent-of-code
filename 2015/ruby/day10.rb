def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

def look_and_say(input)
  rv = ''
  last_char = nil
  cnt = nil
  input.chars.each do |c|
    if last_char.nil?
      last_char = c
      cnt = 1
      next
    end

    if last_char == c
      cnt +=1
      next
    end

    rv += [cnt, last_char].join
    last_char = c
    cnt = 1
  end
  rv += [cnt, last_char].join
end

[['11', '1'], ['21', '11'], ['1211', '21'], ['312211', '111221']].each do |(exp, inp)|
  assert_equal(exp, look_and_say(inp))
end

input = '1113222113'
40.times { input = look_and_say(input)}
puts input.size