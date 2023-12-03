def process(step, iters)
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

process(304, 2017)