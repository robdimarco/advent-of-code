sample=<<~TXT.lines.map(&:strip)
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
TXT

real = File.open("day3.txt").read.lines.map(&:strip)

def part1(data)
  nums = []
  data.each_with_index do |line, y|
    num = ""
    touches = false
    line.chars.each_with_index do |c, x|
      if c =~ /\d/
        num += c
        unless touches
          [-1, 0, 1].each do |dx|
            [-1, 0, 1].each do |dy|
              x1 = x + dx
              y1 = y + dy
              next if x1 < 0 || y1 < 0 || x1 >= line.length || y1 >= data.length
              touches ||= !!(data[y1][x1] =~ /[^\d\.]/)
              # puts "#{c} at #{x},#{y} touches #{data[y1][x1]} at #{x1}, #{y1}" if touches
            end
          end
        end
      else
        # puts "skip #{num} #{touches}"
        nums << num.to_i if num != "" && touches
        num = ""
        touches = false
      end
    end
    nums << num.to_i if num != "" && touches
  end
  # puts nums
  nums.sum
end

def part2(data)
  gears = []
  nums = []
  data.each_with_index do |line, y|
    nx = nil
    line.chars.each_with_index do |c, x|
      if c =~ /\d/
        nx ||= x
      else
        nums.push({y: y, x1: nx, x2: x, value: line[nx..x].to_i}) unless nx.nil?
        nx = nil
      end

      if c == "*"
        gears += [{x: x, y: y}]
      end
    end
    nums.push({x1: nx, x2: line.size - 1, y: y, value: line[nx..-1].to_i}) unless nx.nil?
  end


  gears.map do |g|
    matches = nums.select do |num|
      ymatch = (num[:y] - g[:y]).abs <= 1
      xmatch = (num[:x1]...num[:x2]).any? {|x| (x-g[:x]).abs <= 1}
      # puts "For gear at #{g} looking at #{num}: ym #{ymatch}, xm: #{xmatch} "
      ymatch && xmatch
    end
    # puts "matches: #{matches.size}"
    if matches.size == 2
      a, b = matches
      a[:value] * b[:value]
    else
      0
    end
  end.sum
end

# puts part1(sample)
# puts part1(real)


puts part2(sample)
puts part2(real)
