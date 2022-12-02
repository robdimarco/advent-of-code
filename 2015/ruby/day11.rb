def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end

def valid_letters?(password)
  %w(i o l).none? {|f| password.include?(f)}
end
def has_straight?(password)
  bytes = password.bytes
  i = 0
  while i < password.size - 2 do
    return true if (bytes[i] + 1 == bytes[i+1]) && (bytes[i+1] +1 == bytes[i+2])
    i += 1
  end
  false
end

def has_pairs?(password)
  i = 0
  cnt = 0
  chars = password.chars
  while i < password.size - 1 do
    if chars[i] == chars[i+1]
      cnt +=1
      i +=1
    end
    i += 1
  end
  cnt > 1
end

def valid_password(password)
  # puts "Checking #{password}"
  valid_letters?(password) && has_straight?(password) && has_pairs?(password)
end

def increment_password(password)
  while true do
    bytes = password.bytes
    i = bytes.length - 1
    while i >= 0 do
      bytes[i] += 1
      break if bytes[i] <= 122
      bytes[i] = 97
      i -= 1
    end
    password = bytes.map(&:chr).join
    return password if valid_password(password)
  end
end
assert_equal(false, valid_password('hijklmmn'))
assert_equal(false, valid_password('abbceffg'))
assert_equal(false, valid_password('abbcegjk'))
assert_equal(true, valid_password('abcdffaa'))
assert_equal(true, valid_password('ghjaabcc'))
assert_equal('abcdffaa', increment_password('abcdefgh'))
# assert_equal('ghjaabcc', increment_password('ghijklmn'))
puts "part 1 #{increment_password('hxbxwxba')}"