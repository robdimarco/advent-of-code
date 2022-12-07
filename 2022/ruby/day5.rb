def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read('day5.txt')
SAMPLE = <<-TXT
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
TXT

def rearrange(data, retain: false)
  lines = data.lines
  stacks = Hash.new {|h,k| h[k] = []}
  moves = []

  lines.each do |line|
    if line =~ /^[\s\[A-Z\]]+$/
      (0..line.size/4).each do |n|
        stacks[n].push(line[(4*n) + 1])  if ('A'..'Z').include?(line[(4*n) + 1])
      end

    elsif line.empty? || line =~ /^[\s\d]+$/
    else
      moves.push(line.scan(/\d+/).map(&:to_i))
    end
  end
  moves.each do |(cnt, from, to)|
    to_move = stacks[from - 1][0...cnt]
    # require 'debug';binding.break if to_move.empty?
    # puts "Move #{cnt} from #{from} to #{to} got #{to_move.size}. From has #{stacks[from - 1].size} to has #{stacks[to - 1]}"

    stacks[from - 1].shift(cnt)
    to_move.reverse! if retain
    to_move.each do |i|
      stacks[to - 1].unshift(i)
    end
    # puts "  Done. From has #{stacks[from - 1].size} to has #{stacks[to - 1]}"
    # puts stacks
  end
  stacks.keys.sort.map {|n| stacks[n][0]}.join
end

assert_equal('CMZ', rearrange(SAMPLE))
puts "Part 1: #{rearrange(DATA)}"

assert_equal('MCD', rearrange(SAMPLE, retain: true))
puts "Part 2: #{rearrange(DATA, retain: true)}"
