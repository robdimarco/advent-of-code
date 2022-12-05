def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'digest'
DIRS = [['U', [-1, 0]], ['D', [1, 0]], ['L', [0, -1]], ['R', [0, 1]]]
ENDPOINT = [3, 3]

def shortest_path(code, route: "", pos: [0, 0], path: [], longest_path: false)
  # puts "At #{pos.inspect} from #{route}"
  return route if pos == ENDPOINT

  hex = Digest::MD5.hexdigest(code + route)

  open_doors = (0..3).map {|n| ('b'..'f').include?(hex[n]) ? DIRS[n] : nil}.compact

  return nil if open_doors.empty?

  new_path = [pos] + path
  possible_routes = open_doors.map do |(label, delta)|
    dx, dy = delta
    new_pos = [dx + pos[0], dy + pos[1]]
    next if new_pos[0] < 0 || new_pos[0] > ENDPOINT[0] || new_pos[1] < 0 || new_pos[1] > ENDPOINT[1]
    
    [label, new_pos]
  end.compact

  if longest_path
    possible_routes.reject! do |(label, new_pos)|
      possible_routes.size > 1 && new_pos == ENDPOINT
    end
  end

  routes = possible_routes.map do |(label, new_pos)|
    shortest_path(code, route: route + label, pos: new_pos, path: new_path, longest_path: longest_path)
  end.compact

  # puts routes.inspect if longest_path
  # require 'debug'
  # binding.break if longest_path && path.empty?
  longest_path ? routes.max_by(&:size) : routes.min_by(&:size)
end

# assert_equal("DDRRRD", shortest_path("ihgpwlah"))
# assert_equal("DDUDRLRRUDRD", shortest_path("kglvqrro"))
# assert_equal("DRURDRUDDLLDLUURRDULRLDUUDDDRR", shortest_path("ulqzkmiv"))


# puts "Part 1: #{shortest_path("dmypynyp")}"

def longest_path(code)
  shortest_path(code, longest_path: true)
end

assert_equal(492, longest_path('kglvqrro').size)
assert_equal(830, longest_path('ulqzkmiv').size)
puts "Part 2: #{longest_path("dmypynyp").size}"
# assert_equal(370, longest_path('ihgpwlah').size)
