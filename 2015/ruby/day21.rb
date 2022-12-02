def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day21.txt')
Player = Struct.new(:name, :hp, :damage, :armor, :spend)
Item = Struct.new(:name, :cost, :damage, :armor)

def parse(text)
  text.lines.map do |l|
    name, cost, damage, armor = l.strip.split(/\s+/)
    Item.new name, cost.to_i, damage.to_i, armor.to_i
  end
end
WEAPONS = parse <<~TEXT
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0
TEXT

ARMOR = parse <<~TEXT
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5
TEXT

RINGS = parse <<~TEXT
Damage+1    25     1       0
Damage+2    50     2       0
Damage+3   100     3       0
Defense+1   20     0       1
Defense+2   40     0       2
Defense+3   80     0       3
TEXT

def gear_up(hp)
  weapon = WEAPONS.sample
  armor = ARMOR[rand(ARMOR.size + 1)]
  ring_order = (0..RINGS.size).to_a.shuffle
  rings = (0...rand(3)).map {|n| RINGS[ring_order[n]]}.compact
  items = [weapon, armor, rings].flatten.compact

  Player.new('player', hp, items.map(&:damage).sum, items.map(&:armor).sum, items.map(&:cost).sum)
end

def battle(a, b)
  # puts [a,b].join(" fights ") if 
  b.hp -= [a.damage - b.armor, 1].max
  # puts b.hp
  if b.hp <= 0
    # puts "winner #{a}"
    a
  else 
    battle(b, a)
  end
end

def boss
  Player.new('boss', 100, 8, 2, nil)
end

# puts battle(Player.new('player', 100, 4, 0, 8), boss)

winners = []
losers = []
10000.times do 
  player = gear_up(100)
  winner = battle(player, boss)
  if winner.name == 'player'
    winners <<  winner 
  else
    losers << player
  end
end
puts "Most efficient: #{winners.sort_by(&:spend).first}"
puts "Least efficient: #{losers.sort_by(&:spend).last}"
