def part1
  a = 783
  b = 325
  am = 16807
  bm = 48271
  cnt = 0
  mask = 2**16 -1

  times = 40_000_000
  times.times do
    a *= am
    b *= bm
    a %= 2**31 -1
    b %= 2**31 -1
    if a & mask == b & mask
      cnt +=1
    end
  end
  puts cnt
end
# part1

def part2
  # a = 65
  # b = 8921
  a = 783
  b = 325
  am = 16807
  bm = 48271
  cnt = 0
  mask = 2**16 -1

  times = 5_000_000
  times.times do
    loop do
      a *= am
      a %= 2**31 -1
      break if a % 4 == 0
    end
    loop do 
      b *= bm
      b %= 2**31 -1
      break if b % 8 == 0
    end
    
    if a & mask == b & mask
      cnt +=1
    end
  end
  puts cnt
end
part2