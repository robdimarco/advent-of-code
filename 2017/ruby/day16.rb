instructions = %w(
s1
x3/4
pe/b
)
instructions = File.read("day16.txt").split(',')
# stream = "abcde"
stream = "abcdefghijklmnop"

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
puts stream
