sample=<<~TXT.lines.map(&:strip)
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
TXT
sample2=<<~TXT.lines.map(&:strip)
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
TXT
real = File.open("day20.txt").read.lines.map(&:strip)

Mod = Struct.new(:name, :type, :state, :last_seen, :dest, :cycle_count) do 
  def con?
    type == :con
  end
  def receive(src, pulse, iter)
    case type
    when :con
      last_seen[src] = pulse
      pulse = last_seen.values.uniq == [:high] ? :low : :high
      self.cycle_count = iter if cycle_count == 0 && pulse == :high
      dest.map { |d| [d, pulse] }
    when :flip
      if pulse == :low
        if state == :low 
          self.state = :high
        else
          self.state = :low
        end
        dest.map { |d| [d, state] }
      else
        []
      end
    else
      dest.map { |d| [d, pulse] }
    end
  end
end

def parse(data)
  rv = {}
  data.each do |line|
    a, b = line.split('->').map(&:strip)
    dest = b.strip.split(/\s*,\s*/)
    v = case a[0]
    when '%'
      Mod.new(a[1..-1], :flip, :low, nil, dest)
    when '&'
      Mod.new(a[1..-1], :con, nil, {}, dest, 0)
    else
      Mod.new(a, :other, nil, nil, dest)
    end
    rv[v.name] = v
  end
  rv.values.each do |v|
    v.dest.each do |d|
      vv = rv[d]
      if vv && vv.con?
        vv[:last_seen][v[:name]] = :low
      end
    end
  end
  rv
end

def lcm(nums)
  rv = Hash.new(0)
  nums.each do |n|
    f = factors(n)
    f.each do |ff, c|
      rv[ff] = c if rv[ff] < c
      # puts rv.inspect
    end
  end
  rv.map {|k,v| k**v}.reduce(:*)
end

def factors(num)
  factors = []
  i = 2
  loop do
    if num % i == 0
      num = num / i
      factors.push(i)
    else
      i += 1
    end

    break if num == 1
  end
  factors.each_with_object(Hash.new(0)) {|n, h| h[n] += 1}
end

def part1(data)
  graph = parse(data)
  # puts graph.inspect
  low_count = 0
  high_count = 0
  1000.times do |i|
    queue = [['button', 'broadcaster', :low]]
    until queue.empty? do
      src, d, pulse = queue.pop
      if pulse == :low
        low_count +=1 
      else
        high_count +=1
      end
      node = graph[d]
      next if node.nil?

      node.receive(src, pulse, i).each do |v|
        # puts "#{d} #{v[1]}->#{v[0]}"
        queue.unshift([d, v[0], v[1]])
      end
    end
    # puts "low: #{low_count} High: #{high_count}"
  end
  low_count * high_count
end

def part2(data)
  graph = parse(data)
  rx_a = graph.values.select {|n| n.dest.include?("rx")}
  # puts rx_a.map(&:name)
  rx_b = graph.values.select {|n| (n.dest & rx_a.map(&:name)).any?}
  # puts rx_b.map(&:name)
  i = 0
  loop do
    queue = [['button', 'broadcaster', :low]]
    i += 1
    until queue.empty? do
      return lcm(rx_b.map(&:cycle_count)) if rx_b.all? {|nn| nn.cycle_count > 0}
      src, d, pulse = queue.pop

      if d == "rx"
        return 1 if pulse == :low
      end
      node = graph[d]
      next if node.nil?
      node.receive(src, pulse, i).each do |v|
        queue.unshift([d, v[0], v[1]])
      end
    end
  end
end

puts part1(sample)
puts part1(sample2)
puts part1(real)

# puts part2(sample)
puts part2(real)