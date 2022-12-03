def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

require 'digest'
SEED = 'ojvtpuvg'
def passcode(seed)
  rv = []
  i = 0
  while rv.size < 8 do
    v = Digest::MD5.hexdigest [seed, i].join
    if v[0..4] == '00000'
      rv << v[5]
      print '.'
    end
    i += 1
  end
  rv.join
end
# assert_equal('18f47a30', passcode('abc'))
puts "Part1 #{passcode(SEED)}"