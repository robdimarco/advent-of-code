def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day11.txt')

Item = Struct.new(:type, :elem) do
  def to_s
    @s ||= [type, elem].join(':')
  end
  def <=>(other)
    [type, elem] <=> [other.type, other.elem]
  end
  def pair?(other)
    elem == other.elem && type != other.type
  end
end

def blowup?(floor)
  items_by_type = floor.group_by(&:type).transform_values {|v| v.map(&:elem)}
  return false unless items_by_type[:chip] && items_by_type[:gen]
  chips_no_gen = items_by_type[:chip] -  items_by_type[:gen]

  return false if chips_no_gen.empty?

  (items_by_type[:gen] - items_by_type[:chip]).any?
end

assert_equal(false, blowup?([]))
assert_equal(false, blowup?([Item.new(:gen,:H), Item.new(:gen,:Li)]))
assert_equal(false, blowup?([Item.new(:chip,:H), Item.new(:chip,:Li)]))
assert_equal(true, blowup?([Item.new(:chip,:H), Item.new(:gen,:Li)]))
assert_equal(false, blowup?([Item.new(:chip,:H), Item.new(:gen,:Li), Item.new(:gen,:H)]))
assert_equal(false, blowup?([Item.new(:chip,:H), Item.new(:chip,:Li), Item.new(:gen,:Li), Item.new(:gen,:H)]))

def cache_key(floors, elevator)
  elements = []
  transformed = floors.map do |f|
    f.map do |item|
      idx = elements.index(item.elem)
      if idx == -1
        idx = elements.size
        elements << item.elem
      end
      [idx, item.type]
    end.sort
  end
  [elevator, transformed]
end

def shortest_path(start)
  elevator = 0
  path = []
  success = []

  to_check = [[start, 0, path]]
  checked = {}
  while to_check.any?
    floors, elevator, path = to_check.shift

    result, next_steps = check_floor(floors, elevator, path, success)

    break if result == :success
    puts "Checking. QD #{to_check.size} Path: #{path.size} Success: #{success.size} Checked: #{checked.size}" if rand(1000) == 0

    if next_steps
      next_steps.each do |next_step|
        ckey = cache_key(next_step[0], next_step[1])
        to_check.push(next_step) unless checked.include?(ckey)
        checked[ckey] = 1
      end
    end
  end
  success.map(&:size).min || -1
end

def check_floor(start, elevator, path, success)
  ckey = cache_key(start, elevator)
  if start.any? {|f| blowup?(f)}
    return :blowup
  end

  if start[0..-2].all?(&:empty?)
    success.push(path.dup)
    return :success
  end

  path.unshift(ckey)
  item_combos = ([nil] + start[elevator]).combination(2).to_a.map(&:compact)
  item_combos.reject! {|items| items.size==2 && !items[0].pair?(items[1])}

  elems, gens = start[elevator].partition {|item| item.type == :elem }
  paired_elems = elems.select {|i| gens.any? {|g| g.pair?(i)}}
  if paired_elems.size > 1
    item_combos.reject {|items| items.size == 2 && items[0].pair?(item[1]) && items[0].elem != paired_elems[0].elem}
  end
  elevator_moves = if elevator == 0 
    [1]
  elsif elevator == start.size - 1
    [-1]
  elsif elevator == 1 && start[0].empty?
    [1]
  elsif elevator == 2 && start[1].empty? && start[0].empty?
    [1]
  else
    [1, -1]
  end

  to_check = []
  elevator_moves.each do |move|
    item_combos.each do |items|
      floors = start.map(&:dup)

      new_elevator = elevator + move

      floors[elevator] = floors[elevator].reject {|i| items.include?(i)}
      floors[new_elevator] += items
      if !path.include?(cache_key(floors, new_elevator))
        to_check.push([floors, new_elevator, path.dup])
      end
    end
  end

  [:continue, to_check]
end

DATA = [
  [
    Item.new(:gen, :Po), 
    Item.new(:gen, :Th), 
    Item.new(:chip, :Th), 
    Item.new(:gen, :Pr),
    Item.new(:gen, :Ru), 
    Item.new(:chip, :Ru), 
    Item.new(:gen, :Co), 
    Item.new(:chip, :Co),
    Item.new(:gen, :El), 
    Item.new(:chip, :El),
    Item.new(:gen, :Dl), 
    Item.new(:chip, :Dl)
  ],
  [Item.new(:chip, :Po), Item.new(:chip, :Pr)],
  [],
  []
]

assert_equal(0, shortest_path([[Item.new(:gen,:Li)]]))
assert_equal(0, shortest_path([[], [Item.new(:gen,:Li)]]))
assert_equal(1, shortest_path([[Item.new(:chip, :H)], []]))
assert_equal(-1, shortest_path([[], [Item.new(:chip, :H), Item.new(:gen,:Li)]]))

assert_equal(2, shortest_path([[Item.new(:chip, :H), Item.new(:gen,:H)], [], []]))
assert_equal(3, shortest_path([[Item.new(:chip, :H), Item.new(:gen,:H)], [], [], []]))


# assert_equal(3, iteration([
#   [],
#   [],
#   [Item.new(:gen, :L), Item.new(:gen, :H), Item.new(:chip, :H)],
#   [Item.new(:chip, :L)]
# ], elevator: 2)
# )

# assert_equal(2, iteration([
#   [],
#   [],
#   [Item.new(:chip, :H)],
#   [Item.new(:gen, :L), Item.new(:gen, :H), Item.new(:chip, :L)]
# ], elevator: 3))


# assert_equal(1, iteration([
#   [],
#   [],
#   [Item.new(:chip, :H), Item.new(:chip, :L)],
#   [Item.new(:gen, :L), Item.new(:gen, :H)]
# ], elevator: 2))

sample = [
  [Item.new(:chip, :H), Item.new(:chip, :L)],
  [Item.new(:gen, :H)],
  [Item.new(:gen, :L)],
  []
]
# assert_equal(9, shortest_path(sample))
puts "Part 1: #{shortest_path(DATA)}"
