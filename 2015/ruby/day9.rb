def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day9.txt')

sample = <<~TXT
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
TXT

def distance(routes, start, destinations)
  raise 'Doh..no destinations' if destinations.length == 0
  return routes[start][destinations[0]] if destinations.length == 1

  distances = destinations.map do |destination|
    routes[start][destination] + distance(routes, destination, destinations - [destination])
  end

  distances.min
end

def load_routes(data)
  routes = {}
  data.lines.each do |line|
    locs, dist = line.strip.split(' = ')
    l1, l2 = locs.split(' to ')
    routes[l1] ||= {}
    routes[l2] ||= {}
    routes[l1][l2] = dist.to_i
    routes[l2][l1] = dist.to_i
  end
  routes  
end

def shortest(data)
  routes = load_routes(data)
  routes.keys.map do |start|
    distance(routes, start, routes.keys - [start])
  end.min
end

assert_equal(605, shortest(sample))
puts shortest(data)

