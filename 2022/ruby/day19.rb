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

  def potential_max
    (
      supply['geode'] +   
      (robot_count('geode')..(robot_count('geode') + turns - turn)).inject(:+)
    )
  end

  def max
    supply['geode']
  end

  def potential_quality_score
    potential_max * blueprint.number
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
      if p.type != 'geode' 
        next if robots.count {|r| r == p.type} >= blueprint.max_for_type(p.type) ||
          supply[p.type] >= 2*blueprint.max_for_type(p.type)
      end

      if p.costs.all? {|(amt, type)| supply[type] >= amt}
        new_robots = robots + [p.type]
        new_supply = supply.dup
        p.costs.each {|(amt,type)| new_supply[type] -= amt}

        if p.type == 'geode'
          new_supply['geode'] += turns - turn - 1 
          %w(ore clay obsidian).each do |type|
            new_supply[type] += robot_count(type)
          end
          return [State.new(blueprint, turns, robots, new_supply, turn + 1)]
        else
          x = robot_count(p.type)
          y = supply[p.type]
          t = turns - turn
          z = blueprint.max_for_type(p.type)
          if (x * t)+y < t * z
            rv << State.new(blueprint, turns, new_robots, new_supply, turn + 1)
          end
        end
      end
    end

    rv.each do |s|
      %w(ore clay obsidian).each do |type|
        s.supply[type] += robot_count(type)
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
    end.reverse.compact
    Blueprint.new(num, plans)
  end
end

def quality_score_for_plan(plan)
  run_algo(plan, 24, :quality_score)
end

def max_for_plan(plan)
  run_algo(plan, 32, :max)
end

def run_algo(plan, turns, method)
  q = Containers::PriorityQueue.new
  q.push(State.new(plan, turns), 1)
  seen = Set.new

  done = []
  current_max = 0
  until q.empty? do
    s = q.pop
    puts "P: #{plan.number} D: #{done.size} q: #{q.size} -> T: #{s.turn} M: #{current_max}" if rand(10_000) == 0
    if s.done?
      done << s
      current_max = [current_max, s.send(method)].max
      next
    end

    next_states = s.run
    next_states.each do |ns|
      unless seen.include?(ns.key) || ns.send(:"potential_#{method}") < current_max
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

def part2(input)
  plans = parse(input)
  plans[0..2].map do |plan|
    max_for_plan(plan)
  end.inject(&:*)
end

# assert_equal(9, part1(SAMPLE1))
# assert_equal(24, part1(SAMPLE.lines[1]))
# assert_equal(33, part1(SAMPLE))
# puts "Part 1: #{part1(DATA)}"

# assert_equal(56*62, part2(SAMPLE))
puts "Part 2: #{part2(DATA)}"
