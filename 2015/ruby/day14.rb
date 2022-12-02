def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

data = File.read('day14.txt')
def parse(line)
  match = /(?<rate>\d+).*for (?<t1>\d+) seconds.*rest for (?<t2>\d+) seconds/.match(line)
  raise "Cannot parse #{line}" if match.nil?
  match.named_captures
end
class Reindeer
  def initialize(hsh)
    @rate = hsh['rate'].to_i
    @t1 = hsh['t1'].to_i
    @t2 = hsh['t2'].to_i
  end

  def period
    @t1 + @t2
  end

  def distance(t)
    full_periods = t / period
    partial_period = t % period
    (full_periods * @t1 + [partial_period, @t1].min) * @rate
  end
end

def race(input, t)
  reindeer = input.lines.map {|l| Reindeer.new(parse(l))}
  reindeer.map{|r|r.distance(t)}.max
end
sample = <<~TXT
Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
TXT
assert_equal(1120, Reindeer.new(parse("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.")).distance(1_000))
assert_equal(1056, Reindeer.new(parse("Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.")).distance(1_000))
assert_equal(1120, race(sample, 1_000))
puts "Part 1: #{race(data, 2503)}"


