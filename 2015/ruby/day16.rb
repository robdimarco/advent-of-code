def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day16.txt')

ticker_tape = <<~TXT
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
TXT

def parse_line(line)
  m = /^Sue (?<sue>\d+): (?<rest>.*)/.match(line)
  raise "Could not parse #{line}" unless m
  vals = Hash[
    m['rest'].scan(/(?<name>[a-z]+): (?<cnt>\d+)/).map {|(n, c)| [n.to_sym, c.to_i]}
  ]
  {sue: m['sue'].to_i}.merge(vals)
end
def parse_clues(data)
  data.lines.map do |l|
    clue, cnt = l.split(': ')
    [clue.to_sym, cnt.to_i]
  end
end

def find_sue(data, ticker_tape)
  clues = parse_clues(ticker_tape)
  sues = data.lines.map {|l| parse_line(l)}
  sues.find do |sue|
    clues.all? do |(clue, cnt)|
      sc = sue[clue]
      next true if sc.nil?

      case clue
      when :cats, :trees
        sc > cnt
      when :pomeranians, :goldfish
        sc < cnt
      else
        sue[clue] == cnt
      end
    end
  end
end
assert_equal({sue: 1, goldfish: 9, cars:0, samoyeds: 9}, parse_line('Sue 1: goldfish: 9, cars: 0, samoyeds: 9'))
puts find_sue(data, ticker_tape)