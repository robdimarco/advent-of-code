def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day24.txt')

sample = <<~TEXT
1
2
3
4
5
7
8
9
10
11
TEXT
BUCKETS = 4
require 'set'
def groupings(data)
  combos = Set.new;
  combos.add([])
  # BUCKETS.times {combos[0].push([])}
  b_target = data.sum / BUCKETS
  # puts combos

  data.sort.reverse.each do |package|
    puts "adding package #{package} from #{combos.size} and target #{b_target}"
    new_combos = Set.new
    combos.each do |combo|
      new_combos.add(combo)
      if combo.sum + package <= b_target
        new_combos.add(combo + [package])
      end
    end

    combos = new_combos
  end
  combos.to_a.select {|a| a.sum == b_target}
end

def qe(data)
  data = data.lines.map(&:to_i)
  groups = groupings(data)
  puts groups.size
  # groups.each do |g|
  #   puts "process #{g.inspect}"
  #   if g.map(&:sum).uniq.size == 1
  #     g = g.sort_by {|gg| [gg.size, gg.reduce(1){|a,n| a*n}]}
  #     # groups.push(g)
  #   end
  # end
  gg = groups.sort_by {|gg| [gg.size, gg.reduce(1){|a,n| a*n}]}.first
  gg.reduce(1){|a,n| a*n}
end

# puts groupings(sample.lines.map(&:to_i)).inspect

assert_equal(44, qe(sample))
puts "Part 1: #{qe(data)}"