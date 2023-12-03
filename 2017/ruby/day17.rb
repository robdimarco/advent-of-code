def part_1(step, iters)
  a = [0]
  pos = 0
  iters.times do |i|
    n = i + 1
    pos = (pos + step) % a.size
    # puts "inserting at #{pos}"
    a = a[0..pos] + [n] + a[pos+1..-1]
    pos += 1
    # puts a.join(' ')
  end
  puts a[pos + 1]
end

part_1(304, 2017)

def part_2(step, iters)
  pos = 0
  curr_after = 0
  iters.times do |i|
    n = i + 1
    pos = (pos + step) % (i + 1)
    # puts "inserting at #{pos}"
    # a = a[0..pos] + [n] + a[pos+1..-1]
    curr_after = n if pos == 0
    # puts "updating to #{curr_after}"
    pos += 1
    # puts a.join(' ')
  end
  puts curr_after
end
part_2(304, 50_000_000)
