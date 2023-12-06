sample=<<~TXT.lines.map(&:strip)
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
TXT

real = File.open("day5.txt").read.lines.map(&:strip)


def parse(lines)
  seeds = lines[0].split(' ').map(&:to_i)
  seeds.shift
  transforms = []
  i = 1
  loop do
    break if i >= lines.size
    l = lines[i]
    i+=1
    next if l.empty?


    if l =~ /^\d+/
      transforms[-1].push(l.split(' ').map(&:to_i))
    else
      transforms.push([])
    end
  end
  [seeds, transforms]
end

def part1(data)
  seeds, transforms = parse(data)
  seeds.map do |seed|
    # puts "For seed #{seed}"
    transforms.reduce(seed) do |acc, transform|
      transform.reduce(acc) do |acc2, (dest, start, range)|
        if start <= acc2 && acc2 < start + range
          v = acc2 - start + dest  
          # puts "Match on #{start}..#{start+range}: #{acc2 } => #{v}"
          break v
        else
          acc2
        end
      end
    end
  end.min
end

def part2(data)
  seed_ranges, transforms = parse(data)
  pairs = []
  loop do
    break if seed_ranges.empty?
    s = seed_ranges.shift
    r = seed_ranges.shift
    pairs.push([s, r])
  end
  
  input = pairs
  transforms.each do |transform|
    output = []
    transform.each do |(dest, start, range)|
      next_input = []
      input.each do |pair|
        # puts "Evaluating #{pair} against #{dest} / #{start} / #{range}"
        p_start, p_range = pair
        if start > p_start + p_range || start + range < p_start # start is after end of range, or p_start is after end of transform
          next_input.push(pair)
          # puts "not in range, no change"
          next
        end

        start_offset = 0
        if start > p_start
          next_input.push([p_start, start - p_start])
        else
          start_offset = p_start - start
        end

        interval_start = start + start_offset
        interval_end = [start + range, p_start + p_range].min

        output.push([interval_start - start + dest, interval_end - interval_start])

        if start + range < p_start + p_range
          next_input.push([interval_end, p_start + p_range - start - range])
        end

      end
      input = next_input
      # puts "next input is #{next_input}"
      # break
    end
    # puts "finished with input #{input} and output #{output}"
    # break;
    input += output
  end

  input.map(&:first).min

  # we start with a series of ranges and a set of transforms
  # for each transform, we need create a new series of ranges which serve as input to the next transform
  #   for each transform, we need to look at each range, and find the overlap with the transform range. We then transform the overlap
  # At the end, we can find the minimum value of any of the resulting ranges
end

puts part1(sample)
puts part1(real)

puts part2(sample)
puts part2(real)
