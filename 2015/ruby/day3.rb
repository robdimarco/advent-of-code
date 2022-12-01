def assert_equal(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def house_count(str, actors = 1)
  delivered = {}
  actors.times { |i| delivered[i] = [[0,0]]}
  str.chars.each_with_index do |c, idx|
    actor = idx % actors
    pos = delivered[actor].last
    pos = case c
    when '^'
      [pos[0], pos[1]-1]
    when '>'
      [pos[0] + 1, pos[1]]
    when 'v'
      [pos[0], pos[1]+1]
    when '<'
      [pos[0]-1, pos[1]]
    else
      raise "Invalid dir #{c}"
    end
    delivered[actor].append(pos)
  end
  # puts delivered.values.inspect
  v = delivered.values.reduce([]){|acc, ar| ar.each {|a| acc.append(a)}; acc}
  # puts "v=#{v.inspect}"
  v.uniq.count
end

data = File.read('day3.txt')
puts "Part 1"

assert_equal(2, house_count('^'))
assert_equal(4, house_count('^>v<'))
assert_equal(2, house_count('^v^v^v^v^v'))

puts house_count(data)
puts "Part 2"

assert_equal(3, house_count('^v', 2))
assert_equal(3, house_count('^>v<', 2))
assert_equal(11, house_count('^v^v^v^v^v', 2))
puts house_count(data, 2)

