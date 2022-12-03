def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day8.txt')
sample = <<~TEXT
rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1
TEXT

def visualize(screen)
  screen.map do |row|
    row.map do |col|
      col == 1 ? '#' : '.'
    end.join
  end.join("\n")
end

def execute_line(screen, line)
  tokens = line.split(' ')
  if tokens.first == 'rect'
    a, b = tokens[1].split('x').map(&:to_i)
    (0...b).each do |x|
      (0...a).each do |y|
        screen[x][y] = 1
      end
    end
  elsif tokens.first == 'rotate'
    _, target = tokens[2].split('=')
    target = target.to_i
    amt = tokens[4].to_i

    if tokens[1] == 'column'
      col_size = screen.size
      drop = (0...amt).to_a.reverse.map {|n| screen[col_size - 1 - n][target]}

      (amt...screen.size).to_a.reverse.each do |t|
        # puts "Moving #{screen[t-amt][target] ? '#' :'.'} from #{t-amt} to #{t}"
        screen[t][target] = screen[t-amt][target]
      end
      drop.each_with_index do |d, idx|
        # puts "Moving #{d == 1 ? '#' :'.'} from #{col_size - 1 - idx} to #{idx}"
        screen[idx][target] = d
      end
    elsif tokens[1] == 'row'
      row_size = screen[target].size
      drop = (0...amt).to_a.reverse.map {|n| screen[target][row_size - 1 - n]}
      (amt...screen[target].size).to_a.reverse.each do |t|
        screen[target][t] = screen[target][t-amt]
      end
      drop.each_with_index do |d, idx|
        screen[target][idx] = d
      end
    else
    raise "Invalid rotation #{tokens[1]}"
    end
  else
    raise "Invalid cmd #{tokens.first}"
  end
  screen
end

def execute(file)
  screen = (0...6).map do
    [0] * 50
  end
  # screen = (0...3).map do
  #   [0] * 7
  # end

  file.lines.each do |line|
    execute_line(screen,line.strip)
    # puts visualize(screen)
    # puts
  end
  screen
end

# puts visualize(execute(sample))
puts execute(data).flatten.sum
puts visualize(execute(data))
