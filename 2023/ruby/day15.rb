sample = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
real = File.open("day15.txt").read.strip

def iter(v, c)
  v += c.ord
  v *= 17
  v %= 256
end

def hashf(str)
  str.chars.reduce(0) {|acc, c| iter(acc,c)}
end

def part1(line)
  line.split(',').map do |l|
    hashf(l)
  end.sum
end

def part2(lines)
  data = lines.split(',')
  boxes = (0..255).map { Hash.new }
  data.map do |line|
    md = /([a-z]+)([=\-])(.*)/.match(line)
    # puts "Match #{md}"
    label = md[1]
    op = md[2]
    rest = md[3]
    box = hashf(label)
    case op
    when "="
      boxes[box][label] = rest.to_i
    when "-"
      boxes[box].delete(label)
    else
      raise "Doh....#{op}"
    end
  end
  rv = 0
  boxes.each_with_index do |box, idx|
    box.values.each_with_index do |v, i|
      rv += (1 + idx) * (i + 1) * v
    end
  end
  rv
end
puts part1(sample)
puts part1(real)

sample_2="rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

puts part2(sample_2)
puts part2(real)
