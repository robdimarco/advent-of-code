def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day15.txt')

sample = <<~TXT
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
TXT
def parse_line(line)
  name, rest = line.split(': ')
  capacity, durability, flavor, texture, calories = rest.scan(/[\-\d]+/).map(&:to_i)
  {name: name, capacity: capacity, durability: durability, flavor: flavor, texture: texture, calories: calories}
end

def amts(buckets, total)
  return [[total]] if buckets == 1

  rv = []
  (0..total).each do |n|
    amts(buckets - 1, total - n).each do |old|
      rv.push(old + [n])
    end
  end
  rv
end

def score(ingredients_added)
  score = 0
  values = %i(capacity durability flavor texture).map do |t|
    ingredients_added.map do |(amt, ingredient)|
      amt * ingredient[t]
    end.sum
  end
  values.reduce(1) {|acc, v| acc * [v, 0].max}
end

def highest_score(data)
  ingredients = data.lines.map {|l| parse_line(l)}
  amts = amts(ingredients.size, 100)
  amts.map do |amt|
    score(amt.zip(ingredients))
  end.max
end
assert_equal([[100]], amts(1, 100))
assert_equal([[0,1], [1,0]].sort, amts(2, 1).sort)
assert_equal([[0,2], [1,1], [2,0]].sort, amts(2, 2).sort)
assert_equal([[2,0,0], [1,1,0], [1,0,1], [0, 2, 0], [0, 1, 1], [0, 0, 2]].sort, amts(3, 2).sort)

assert_equal({name: 'Butterscotch', capacity: -1, durability: -2, flavor: 6, texture: 3, calories: 8}, parse_line(sample.lines[0]))

assert_equal(62842880, highest_score(sample))
puts "Part 1: #{highest_score(data)}"