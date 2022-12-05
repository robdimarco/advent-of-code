def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

require 'digest'
def password_index(sample, index: 63)
  i = 0
  pending_confirm = []
  matched = []
  loop do 
    hex = Digest::MD5.hexdigest([sample, i].join)

    pending_confirm = pending_confirm.map do |confirm|
      idx, char, _ = confirm
      # require 'debug'; binding.break
      if i > 1_000 + idx
        nil
      elsif hex.index(char * 5)
        # puts "Matched #{confirm.inspect} at #{i}"
        matched << idx
        matched.sort!
        nil
      else
        confirm
      end
    end.compact
    triples = hex.scan(/(.)\1\1/)

    if triples.any?
      pending_confirm.push([i, triples[0][0], hex])
    end

    break if matched[index] && pending_confirm.none? {|c| c[0] < matched[index]}
    i += 1
  end
  matched[index]
end

sample = 'abc'
data = 'ngcjuoqr'

assert_equal(39, password_index(sample, index: 0))
assert_equal(92, password_index(sample, index: 1))
assert_equal(22728, password_index(sample))
puts "Part 1: #{password_index(data)}"
