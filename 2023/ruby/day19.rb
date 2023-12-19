sample=<<~TXT.lines.map(&:strip)
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
TXT

real = File.open("day19.txt").read.lines.map(&:strip)

Rating = Struct.new(:x, :m, :a, :s) do
  def score
    x + m + a + s
  end
end

Rule = Struct.new(:ops, :default_value) do 
  def evaluate(rating)
    ops.each do |op|
      t = op.evaluate(rating)
      return t unless t.nil?
    end
    default_value
  end
end

Operation = Struct.new(:field, :op, :compare, :target) do
  def evaluate(rating)
    v = rating.send(field)
    target if v.send(op, compare)
  end
end

def parse(lines)
  blank = false
  ratings = []
  rules = {}
  lines.each do |l|
    blank = true and next if l.empty?
    if blank
      ratings.push(Rating.new(*l.scan(/\d+/).map(&:to_i)))
    else
      name, rest = l.split('{')
      ops = rest.delete('}').split(',')
      checks = ops[0..-2].map do |o|
        m = /([a-z])(.)(\d+):([a-zA-Z]+)/.match(o)
        next unless m
        Operation.new m[1].to_sym, m[2].to_sym, m[3].to_i, m[4]
      end
      rules[name] = Rule.new(checks, ops[-1])
    end
  end
  [rules, ratings]
end

def run(rules, ratings)
  rv = 0
  ratings.each do |rating|
    next_rule = 'in'
    loop do 
      next_rule = rules[next_rule].evaluate(rating)
      case next_rule
      when 'A'
        rv += rating.score
        break
      when 'R'
        break
      end
    end
  end
  rv
end

def part1(data)
  run(*parse(data))
end

def part2(data)
end

puts part1(sample)
puts part1(real)

# puts part2(sample)
# puts part2(real)