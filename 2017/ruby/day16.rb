sample_instructions = %w(
s1
x3/4
pe/b
)

instructions = File.read("day16.txt").split(',')
sample_stream = "abcde"
STREAM = "abcdefghijklmnop"

def process(stream, instructions)
  instructions.each do |i|
    if i[0] == "s"
      pos = stream.size - i[1..].to_i
      stream = stream[pos..-1] + stream[0..pos-1]
    elsif i[0] == "x"
      a, b = i[1..].split('/').map(&:to_i).sort
      stream = stream[0...a] + stream[b] + stream[a+1...b] + stream[a] + stream[b+1..]
    elsif i[0] == "p"
      a, b = i[1..].split('/')
      stream = stream.chars.map do |c|
        if c == a
          b
        elsif c == b
          a
        else
          c
        end
      end.join
    end
  end
  stream
end


# puts process(sample_stream, sample_instructions)
puts process(STREAM, instructions)

s = STREAM
h = {s => 0}
1_000_000_000.times do |i|
  # puts "#{i+1}: #{s}"
  s = process(s, instructions)
  if h[s]    
    # puts "dupe found after #{i + 1} transitions from original step #{h[s]} #{s}"
    ii = 1_000_000_000 % (i + 1)
    # puts "Have #{ii} left over from "
    puts h.detect {|k,v| v  == ii}[0]
    break
  end
  h[s] = i + 1
end