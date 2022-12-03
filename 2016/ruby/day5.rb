def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

require 'digest'
SEED = 'ojvtpuvg'
def passcode_1(seed)
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
# assert_equal('18f47a30', passcode_1('abc'))
# puts "Part1 #{passcode_1(SEED)}"


def passcode_2(seed)
  rv = {}
  i = 0
  while rv.size < 8 do
    v = Digest::MD5.hexdigest [seed, i].join
    c = v[5]
    if v[0..4] == '00000'
      if ('0'..'7').include?(c) && rv[c].nil?
        rv[c] = v[6]
        puts v
        # print '.'
      end
    end
    i += 1
  end
  ('0'..'7').map {|n| rv[n]}.join
end
# assert_equal('05ace8e3', passcode_2('abc'))
puts "Part 2 #{passcode_2(SEED)}"
