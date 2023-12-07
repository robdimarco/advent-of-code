sample=<<~TXT.lines.map(&:strip)
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
TXT

real = File.open("day7.txt").read.lines.map(&:strip)

RANKS = %w(A K Q J T 9 8 7 6 5 4 3 2)
RANKS_2 = %w(A K Q T 9 8 7 6 5 4 3 2 J)

def score(hand)
  h = hand.chars.each_with_object(Hash.new(0)) do |c, h|
    h[c] += 1
  end
  m_v = h.values.max
  case m_v 
  when 5
    1
  when 4
    2
  when 3
    h.size == 2 ? 3 : 4
  when 2
    h.size == 3 ? 5 : 6
  else
    7
  end
end
def score_2(hand)
  h = hand.chars.each_with_object(Hash.new(0)) do |c, h|
    h[c] += 1
  end

  mv_x = h.reject{|k,v| k == 'J'}.values.max || 5

  mv_xj = mv_x + h['J']
  
  case mv_xj
  when 5, 10
    1
  when 4
    2
  when 3
    h.count {|k,v| k != 'J' && v >= 2} == 2 ? 3 : 4
  when 2
    h.size == 3 ? 5 : 6
  else
    7
  end
end

def part1(lines)
  data = lines.map {|l| a, b = l.split(' '); [a, b.to_i]}
  rv = data.sort_by do |(card, value)|
    s = score(card)
    [s] + card.chars.map {|c| RANKS.index(c)}
  end
  sum = 0

  rv.reverse.each_with_index do |o, i|
    sum += o.last * (i+1)
  end
  sum
end

def part2(lines)
  data = lines.map {|l| a, b = l.split(' '); [a, b.to_i]}
  rv = data.sort_by do |(card, value)|
    s = score_2(card)
    [s] + card.chars.map {|c| RANKS_2.index(c)}
  end

  sum = 0

  rv.reverse.each_with_index do |o, i|
    sum += o.last * (i+1)
  end
  sum
end

# puts part1(sample)
# puts part1(real)

puts part2(sample)
puts part2(real)
