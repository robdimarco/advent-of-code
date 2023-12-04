sample=<<~TXT.lines.map(&:strip)
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
TXT

real = File.open("day4.txt").read.lines.map(&:strip)

def parse(data)
  data.map do |line|
    card, rest = line.split(':')
    win, mine = rest.split(/\s*\|\s*/)
    wins = win.split(" ").map(&:to_i)
    mines = mine.split(" ").map(&:to_i)
    {card: card.split(' ').last.to_i, wins: wins, mines: mines}
  end
end


def part1(data)
  cards = parse(data)
  cards.map do |card|
    cnt = card[:mines].count {|m| card[:wins].include?(m)}
    if cnt > 0
      2 ** (cnt - 1)
    else
      0
    end
  end.sum
end

def part2(data)
  cards = parse(data)
  card_counts = cards.each_with_object({}) {|o, h| h[o[:card]] = 1}
  # puts card_counts

  cards.each_with_index do |card, idx|
    card_no = card[:card]
    have = card_counts[card_no]
    cnt = card[:mines].count {|m| card[:wins].include?(m)}

    (1..cnt).each do |k|
      card_counts[card_no + k] += have
    end
  end
  card_counts.values.sum
end

# puts part1(sample)
# puts part1(real)

puts part2(sample)
puts part2(real)
