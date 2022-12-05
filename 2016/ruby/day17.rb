def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
require 'digest'
DIRS = [['U', [-1, 0]], ['D', [1, 0]], ['L', [0, -1]], ['R', [0, 1]]]
ENDPOINT = [3, 3]

def shortest_path(code, route: "", pos: [0, 0], path: [])
  # puts "At #{pos.inspect} from #{route}"
  return route if pos == ENDPOINT

  hex = Digest::MD5.hexdigest(code + route)

  open_doors = (0..3).map {|n| ('b'..'f').include?(hex[n]) ? DIRS[n] : nil}.compact

  return nil if open_doors.empty?

  new_path = [pos] + path
  routes = open_doors.map do |(label, delta)|
    dx, dy = delta
    new_pos = [dx + pos[0], dy + pos[1]]
    next if new_pos[0] < 0 || new_pos[0] > ENDPOINT[0] || new_pos[1] < 0 || new_pos[1] > ENDPOINT[1]
    # next if path.include?(new_pos)
    
    shortest_path(code, route: route + label, pos: new_pos, path: new_path)
  end.compact
  routes.min_by(&:size)
end

assert_equal("DDRRRD", shortest_path("ihgpwlah"))
assert_equal("DDUDRLRRUDRD", shortest_path("kglvqrro"))
assert_equal("DRURDRUDDLLDLUURRDULRLDUUDDDRR", shortest_path("ulqzkmiv"))

puts "Part 1: #{shortest_path("dmypynyp")}"