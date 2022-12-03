def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day10.txt')

sample = <<~TEXT
value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2
TEXT
def parse_line(l)
  tokens = l.split(' ')
  case tokens[0]
  when 'bot'
    {
      type: :bot, 
      bot: tokens[1].to_i, 
      low: {target: tokens[5].to_sym, num: tokens[6].to_i}, 
      high: {target: tokens[10].to_sym, num: tokens[11].to_i}
    }
  when 'value'
    {type: :value, value: tokens[1].to_i, bot: tokens[5].to_i}
  end
end

def responsible(instructions, comparison)
  bots = Hash.new {|h,k| h[k] = []}
  outputs = Hash.new {|h,k| h[k] = []}
  comparisons = {}

  instructions = instructions.lines.map(&:strip).map {|l| parse_line(l)}
  while instructions.any?
    instructions = instructions.reject do |i|
      bot = i[:bot]
      if i[:type] == :value
        bots[bot] << i[:value]
      else
        bot_c = bots[bot]
        if bot_c.size == 2
          low, high = bot_c.sort
          comparisons[[low, high]] = bot
          if i[:low][:target] == :output
            outputs[i[:low][:num]] = low
          else
            bots[i[:low][:num]] << low
          end

          if i[:high][:target] == :output
            outputs[i[:high][:num]] = high
          else
            bots[i[:high][:num]] << high
          end
          true
        else
          false
        end
      end
    end.compact
  end
  # puts bots
  # puts outputs
  # puts instructions.size
  puts outputs[0].inspect
  puts outputs[1].inspect
  puts outputs[2].inspect

  comparisons[comparison]
end

assert_equal(2, responsible(sample, [2, 5]))
puts "Part 1 #{responsible(data, [17, 61])}"