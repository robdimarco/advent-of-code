def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day12.txt')

def sum(inp)
  inp.scan(/[\-\d]+/).map(&:to_i).sum
end

[
  [6, "[1,2,3]"],
  [6, "{\"a\":2,\"b\":4}"],
  [3, "[[[3]]]"],
  [3, "{\"a\":{\"b\":4},\"c\":-1}"],
  [0, "{\"a\":[-1,1]}"],
  [0, "[-1,{\"a\":1}]"],
  [0, "{}"],
  [0, "[]"],
].each do |(exp, inp)|
  assert_equal(exp, sum(inp), "Input = #{inp}")
end

puts "Part 1 : #{sum(data)}"