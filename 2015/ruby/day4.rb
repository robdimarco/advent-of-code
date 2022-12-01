
def assert_equal(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

require 'digest'
def first_advent_coin(key, prefix = "00000")
  i = 1
  loop do
    break if calc_hash(key, i).start_with?(prefix)
    i+= 1
  end
  i
end
def calc_hash(key, val)
  Digest::MD5.hexdigest([key, val].join)
end

assert_equal('000001dbbfa', calc_hash('abcdef', 609043)[0..10])
assert_equal('000006136ef', calc_hash('pqrstuv', 1048970)[0..10])

assert_equal(609043, first_advent_coin('abcdef'))
assert_equal(1048970, first_advent_coin('pqrstuv'))

secret_key = 'iwrupvqb'
puts first_advent_coin(secret_key)
puts first_advent_coin(secret_key, "000000")

