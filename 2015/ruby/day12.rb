def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day12.txt')

def sum_json(json, skip_red = false)
  return json if json.is_a?(Fixnum)

  return json.map {|j| sum_json(j, skip_red)}.sum if json.is_a?(Array)

  if json.is_a?(Hash)
    return 0 if skip_red && json.values.any? {|v| v == 'red'}
    return sum_json(json.keys, skip_red) + sum_json(json.values, skip_red)
  end

  0
end
require 'json'
def sum(inp, skip_red = false)
  # inp.scan(/[\-\d]+/).map(&:to_i).sum
  sum_json(JSON.parse(inp), skip_red)
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
  # [4, "[1,{\"c\":\"red\",\"b\":2},3]"],
  # [0, '{"d":"red","e":[1,2,3,4],"f":5}'],
  # [6, '[1,"red",5]']
].each do |(exp, inp)|
  assert_equal(exp, sum(inp), "Input = #{inp}")
end

puts "Part 1 : #{sum(data)}"
puts "Part 2 : #{sum(data, true)}"