def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt')).strip
SAMPLE = <<~TEXT
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
TEXT

def tail_visits(data, knot_count = 2)
  cmds = data.lines.map do |l|
    cmd, cnt = l.strip.split(' ')
    [cmd.to_sym, cnt.to_i]
  end
  moves = {
    'R': [1, 0],
    'L': [-1, 0],
    'U': [0, -1],
    'D': [0, 1]
  }

  spaces = Hash.new(0)
  knot_positions = []
  knot_count.times do
    knot_positions.push([0,0])
  end
  # head_pos = [0,0]
  # tail_pos = [0,0]
  spaces[[0,0]] += 1
  cmds.each do |(cmd, cnt)|
    # puts "Execute #{cmd} #{cnt} on h: #{knot_positions[0].inspect}"
    mvmt = moves[cmd]
    # puts "Moving #{mvmt.inspect}"
    raise "Could not find #{cmd}" if mvmt.nil?
    cnt.times do
      head_pos = knot_positions[0]
      knot_positions[0] = [head_pos[0] + mvmt[0], head_pos[1] + mvmt[1]]
      (1...knot_count).each do |k|
        head_pos = knot_positions[k-1]
        tail_pos = knot_positions[k]
        dist = [head_pos[0] - tail_pos[0], head_pos[1] - tail_pos[1]]
        # puts "Have dist of #{dist}"
        if (dist[0].abs > 1 || dist[1].abs > 1)
          tail_pos = knot_positions[k] = [tail_pos[0] + (dist[0] != 0 ? dist[0].abs/dist[0] : 0), tail_pos[1] + (dist[1].abs != 0 ? dist[1].abs/dist[1] : 0)]
          if k == knot_count - 1
            puts "Moving tail to #{tail_pos}"
            spaces[tail_pos] += 1
          end
          # puts "Moved tail to #{tail_pos.inspect}"
        end
        # head_pos = knot_positions[0] = new_pos
        # puts "Moved head to #{head_pos.inspect}"
      end
    end
  end
  spaces.keys.size
end

assert_equal(13, tail_visits(SAMPLE))
puts "Part 1 #{tail_visits(DATA)}"
SAMPLE_2 =<<~TEXT
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
TEXT
assert_equal(1, tail_visits(SAMPLE, 10))
assert_equal(36, tail_visits(SAMPLE_2, 10))
puts "Part 2 #{tail_visits(DATA, 10)}"