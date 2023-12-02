sample=<<~TXT.lines.map(&:strip)
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
TXT

real = File.open("day2.txt").read.lines.map(&:strip)

def part1(data)
  max = {red: 12, green: 13, blue:  14}
  v = data.map do |line|
    num = line.scan(/\d+/).first.to_i
    rounds = line.split(':').last.strip.split(/; */)
    i = num
    rounds.each do |n|
      pulls = n.split(', ')
      pulls.each do |p|
        cnt, color = p.split(' ')
        color = color.gsub(',', '')
          # puts "round #{num}: break on #{color} with count #{cnt} with max #{max[color.to_sym].to_i}"
        if max[color.to_sym].to_i < cnt.to_i
          i = 0
          # puts "round #{num}: break on #{color} with count #{cnt} with max #{max[color.to_sym].to_i}"
          break
        end
      end
    end
    i
  end.compact.sum
  puts v
end

def part2(data)
    v = data.map do |line|
    num = line.scan(/\d+/).first.to_i
    rounds = line.split(':').last.strip.split(/; */)
    i = num
    max = {}
    rounds.each do |n|
      pulls = n.split(', ')
      pulls.each do |p|
        cnt, color = p.split(' ')
        color = color.gsub(',', '')
        cnt = cnt.to_i
        max[color] = [max[color].to_i, cnt].max
      end
    end
    max.values.inject(:*)
  end.sum
  puts v
end

# part1(sample)
# part1(real)


part2(sample)
part2(real)
