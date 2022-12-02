def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
# plookup = [nil] * 3_000_000
# (2..3_000_000).each do |x|
#   unless plookup[x]
#     n = 2 * x
#     while n < plookup.size
#       plookup[n] = true
#       n += x
#     end
#   end
# end
# primes = []; plookup.each_with_index {|n, idx| primes << idx unless n || idx < 2}.compact
def factors(n)
  @factors ||= {}
  return @factors[n] if @factors[n]
  num = n
  factors = [1, n]
  p = 2
  while num > 1 
    if num % p == 0
      factors << p 
      factors << n / p
    end
    break if p > Math.sqrt(n)
    p += 1

  end
  rv = factors.uniq
  @factors[n] = rv
  rv
end

assert_equal([1,2,3,6], factors(6).sort)
assert_equal([1,3,9], factors(9).sort)
assert_equal([1,2,3,4,6,12], factors(12).sort)
assert_equal([1,2,3,4,6,12], factors(12).sort)
assert_equal([1,2,3,4,6,8,12,24], factors(24).sort)
assert_equal([1,17], factors(17).sort)

input = 29_000_000

def presents(house)
  factors(house).sum * 10
end

def house(target, start=nil)
  n = start || 1
  while true
    return n if presents(n) >= target
    n += 1
    print '.' if n % 10_000 == 0
  end
  # min = 1
  # max ||= target / 2
  # bucket = 200_000
  # while max - min > bucket
  #   h = min + ((min + max) * rand).to_i

  #   presents_in_bucket = []
  #   ((-bucket / 2)..bucket/2).each do |b|
  #     if b + h >= 0
  #       presents_in_bucket << [b + h, presents(b + h)]
  #     end
  #   end

  #   over_target = presents_in_bucket.find {|(n, p)| p >= target}

  #   if over_target
  #     max = [over_target.first, max].min
  #   else
  #     min = [presents_in_bucket.map(&:first).max, min].max
  #   end
  #   puts [min, max].join(' ')
  # end

  # (min..max).find do |n|
  #   presents(n) >= target
  # end
end

assert_equal(1, house(2))
assert_equal(6, house(100))

puts "Part 1: #{house(29_000_000, 100_000)}"