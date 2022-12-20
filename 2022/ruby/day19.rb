def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
  print '.'
end
require 'debug'
require 'algorithms'
require 'set'
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip

SAMPLE1 = <<~TEXT
Blueprint 1: Each ore robot costs 4 ore.  Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
TEXT

SAMPLE = <<~TEXT
Blueprint 1: Each ore robot costs 4 ore.  Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore.  Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
TEXT
Plan = Struct.new(:type, :costs)
Blueprint = Struct.new(:number, :plans) do
  def max_for_type(type)
    @max_for_type ||= plans.each_with_object(Hash.new(0)) do |plan, hsh|
      plan.costs.each do |(amt, type)|
        hsh[type] = [hsh[type], amt].max
      end
    end
    @max_for_type[type]
  end
end

class State
  attr_reader :supply, :blueprint, :turn, :robots, :turns

  def initialize(blueprint, turns = 24, robots = ['ore'], supply = Hash.new(0), turn = 0)
    @blueprint = blueprint
    @turns = turns
    @robots = robots
    @supply = supply
    @turn = turn
  end
  
  def key
    [@turn, @robots.sort, @supply]
  end

  def done? 
    turn == turns
  end

  def potential_qs
    (
      (supply['geode']..(supply['geode'] + turns - turn)).inject(:+)
    ) * blueprint.number
  end

  def quality_score
    supply['geode'] * blueprint.number
  end

  def robot_count(type)
    robots.count {|n| n == type}
  end

  def priority
    robots.sum do |r|
      case r
      when 'geode'
        4*turns
      when 'obsidian'
        3*turns
      when 'clay'
        2*turns
      when 'ore'
        1*turns
      end
    end
  end

  def run
    return [self] if done?
    rv = [State.new(blueprint, turns, robots, supply.dup, turn + 1)]
    blueprint.plans.each do |p|
      if p.type != 'geode' && robots.count {|r| r == p.type} >= blueprint.max_for_type(p.type)
        next
      end
      if p.costs.all? {|(amt, type)| supply[type] >= amt}
        new_robots = robots + [p.type]
        new_supply = supply.dup
        p.costs.each {|(amt,type)| new_supply[type] -= amt}
        rv << State.new(blueprint, turns, new_robots, new_supply, turn + 1)
        # break
      end
    end
    rv.each do |s|
      robots.each do |r|
        s.supply[r] += 1
      end
    end

    rv
  end
end

def parse(data)
  data.strip.lines.map do |l|
    bp, rest = l.split(': ')
    num = bp.split(' ')[1].to_i
    plans = rest.split('.').map do |s|
      next if s.strip.empty?
      p1, p2 = s.strip.split('robot costs')
      type = p1.strip.split(' ')[1]
      costs = p2.strip.split(' and ').map do |e| 
        n, t = e.split(' ')
        [n.to_i, t]
      end
      Plan.new(type, costs)
    end.compact
    Blueprint.new(num, plans)
  end
end

def quality_score_for_plan(plan)
  q = Containers::PriorityQueue.new
  q.push(State.new(plan), 1)
  seen = Set.new
  done = []
  current_max = 0
  until q.empty? do
    s = q.pop
    puts "P: #{plan.number} D: #{done.size} q: #{q.size} -> T: #{s.turn} M: #{current_max}" if rand(10_000) == 0
    if s.done?
      done << s
      # puts [s.supply, s.robots, s.turn].inspect
      current_max = [current_max, s.quality_score].max
      next
    end

    next_states = s.run
    next_states.each do |ns|
    # puts "Breaking on #{ns.inspect}" if ns.potential_qs < current_max
      unless seen.include?(ns.key) || ns.potential_qs < current_max
        q.push(ns, ns.priority)
        seen.add(ns.key)
      end
    end
  end
  current_max
end

def part1(input)
  plans = parse(input)
  plans.map do |plan|
    quality_score_for_plan(plan)
  end.sum
end

bp = Blueprint.new(1, [
  Plan.new('ore', [[4, 'ore']]),
  Plan.new('clay', [[2, 'ore']]),
  Plan.new('obsidian', [[3, 'ore'], [14, 'clay']]),
  Plan.new('geode', [[2, 'ore'], [7, 'obsidian']])
  ]
)
state = State.new(
  bp, 
  24, 
  ['ore', 'clay', 'clay', 'clay', 'clay', 'obsidian', 'obsidian', 'geode', 'geode'],
  {'ore' => 5, 'clay' => 37, 'obsidian' => 6, 'geode' => 7},
  4
)
#<State:0x0000000106653c70 @blueprint=#<struct Blueprint number=1, plans=[#<struct Plan type="geode", costs=[[2, "ore"], [7, "obsidian"]]>, #<struct Plan type="obsidian", costs=[[3, "ore"], [14, "clay"]]>, #<struct Plan type="clay", costs=[[2, "ore"]]>, #<struct Plan type="ore", costs=[[4, "ore"]]>]>, @turns=24, @robots=["ore", "clay"], @supply={"ore"=>2, "clay"=>1}, @turn=4>
# pp state.potential_qs
# pp state.run
# puts state.inspect

# assert_equal(9, part1(SAMPLE1))
# assert_equal(24, part1(SAMPLE.lines[1]))
assert_equal(33, part1(SAMPLE))
puts "Part 1: #{part1(DATA)}"