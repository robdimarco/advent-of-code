def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
Effect = Struct.new(:name, :rounds, :action) do
  def active?; rounds > 0; end
  def armor; action[:armor].to_i; end
  def damage; action[:damage].to_i; end
  def mana; action[:mana].to_i; end
end
Player = Struct.new(:name, :hp, :damage, :mana, :spent, :spells) do
  def player?; name == 'player'; end
  def boss?; !player?; end

  def buy_spell(val)
    self.mana -= val
    self.spent = self.spent.to_i + val
    self.spells ||= []
    self.spells.push(val)
  end
end

magic_missile = {
  name: :magic_missile,
  cost: 53,
  action: {type: :instant, damage: 4}
}
drain = {
  name: :drain,
  cost: 73,
  action: {type: :instant, damage: 2, heal: 2}
}
shield = {
  name: :shield,
  cost: 113,
  action: {type: :effect, lasts: 6, armor: 7}
}
poison = {
  name: :poison,
  cost: 173,
  action: {type: :effect, lasts: 6, damage: 3}
}
recharge = {
  name: :recharge,
  cost: 229,
  action: {type: :effect, lasts: 5, mana: 101}
}

SPELLS = [magic_missile, drain, shield, poison, recharge]

def sum_effects(effects)
  rv = Hash.new(0)
  effects.each do |effect|
    # puts "Applying effect #{effect}"
    effect.rounds -= 1
    rv[:armor] += effect.armor
    rv[:damage] += effect.damage
    rv[:mana] += effect.mana
  end

  rv
end

# [173, 229, 173, 173, 53, 53
# TEST_SPELLS = [poison, recharge, poison, poison, magic_missile, magic_missile]

def action(a, b, effects)
  # puts "a: #{a} b: #{b}"
  effect_impacts = sum_effects(effects)
  player, boss = [a,b].partition(&:player?).map(&:first)

  boss.hp -= effect_impacts[:damage]
  player.mana += effect_impacts[:mana]

  if a.player?
    spell = SPELLS.select do |s| 
      s[:cost] <= a.mana && effects.none? {|e| e.name == s[:name]}
    end.sample
    # spell = TEST_SPELLS.shift
    # puts "Using spell #{spell}"
    if spell
      a.buy_spell(spell[:cost])
      case spell[:action][:type]
      when :instant
        a.hp += spell[:action][:heal].to_i
        b.hp -= spell[:action][:damage].to_i
      when :effect
        effects.push(Effect.new(spell[:name], spell[:action][:lasts], spell[:action]))
      else
        raise "Invalid type #{spell[:action][:type]}"
      end
    end
  else
    if a.hp > 0
      # puts "Boss attack"
      b.hp -= [a.damage - effect_impacts[:armor], 1].max
    end
  end
end

def battle(a, b, effects=[])
  action(a, b, effects)

  if b.hp <= 0
    a
  else 
    effects = effects.select(&:active?)
    battle(b, a, effects)
  end
end
winners = []
losers = []
100_000.times do 
  # player = Player.new('player', 10, nil, 250)
  # boss = Player.new('boss', 14, 8)
  player = Player.new('player', 50, nil, 500)
  boss = Player.new('boss', 55, 8)
  winner = battle(player, boss)

  if winner.player?
    winners << winner 
  else
    losers << player
  end
end
puts "Most efficient: #{winners.sort_by(&:spent).first}"
puts "Least efficient: #{losers.sort_by(&:spent).last}"
