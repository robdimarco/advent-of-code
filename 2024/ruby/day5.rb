TEST_DATA =<<~DATA.lines.map(&:strip)
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
DATA
REAL_DATA = File.read('day5.txt').lines.map(&:strip)

def parse(data)
  rules = []
  updates = []
  data.each do |l|
    if l =~ /\|/
      rules.push(l.split('|').map(&:to_i))
    elsif l =~ /,/
      updates.push(l.split(',').map(&:to_i))
    end
  end
  [rules, updates]
end

def valid_update?(rules, update)
  (1...update.size).each do |i|
    (0...i).each do |j|
      if rules.include?([update[i], update[j]])
        return false 
      end
    end
  end
  true
end

def part1(data)
  rules, updates = parse(data)
  rv = 0
  updates.each do |update|
    if valid_update?(rules, update)
      n = (update.size - 1) / 2
      rv += update[n]
    end
  end
  rv
end

def reorder(rules, update)
  update.sort do |a, b|
    if rules.include?([a,b])
      -1
    elsif rules.include?([b,a])
      1
    else
      0
    end
  end
end

def part2(data)
  rules, updates = parse(data)
  rv = 0
  updates.each do |update|
    if !valid_update?(rules, update)
      reordered = reorder(rules, update)
      n = (reordered.size - 1) / 2
      rv += reordered[n]
    end
  end
  rv
end

puts part1(TEST_DATA)
puts part1(REAL_DATA)
puts part2(TEST_DATA)
puts part2(REAL_DATA)