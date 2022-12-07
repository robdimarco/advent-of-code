def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day2.txt')
sample = <<~TXT
A Y
B X
C Z
TXT

def parse_line(line)
  him, me = line.strip.split(' ')

  [him, me]
end

def total_score(data)
  score = 0
  scores = {
    rock: 1, paper: 2, scissors: 3
  }
  beats = {
    rock: :scissors, paper: :rock, scissors: :paper
  }

  data.lines.map do |line|
    him, me = parse_line(line)
    him = case him
      when 'A'
        :rock
      when 'B'
        :paper
      when 'C'
        :scissors
      end
      me = case me
      when 'X'
        :rock
      when 'Y'
        :paper
      when 'Z'
        :scissors
      end
    s = if him == me 
      3
    elsif beats[me] == him
      6
    else
      0
    end
    score += s + scores[me]
  end
  score
end

assert_equal(15, total_score(sample))
puts "Part 1: #{total_score(data)}"

def total_score_2(data)
  score = 0
  scores = {
    rock: 1, paper: 2, scissors: 3
  }
  beats = {
    rock: :scissors, paper: :rock, scissors: :paper
  }

  data.lines.map do |line|
    him, me = parse_line(line)
    him = case him
    when 'A'
      :rock
    when 'B'
      :paper
    when 'C'
      :scissors
    end
    me = case me
    when 'X'
      beats[him]
    when 'Y'
      him
    when 'Z'
      beats.invert[him]
    end

    s = if him == me 
      3
    elsif beats[me] == him
      6
    else
      0
    end
    score += s + scores[me]
  end
  score
end

assert_equal(12, total_score_2(sample))
puts "Part 2: #{total_score_2(data)}"
