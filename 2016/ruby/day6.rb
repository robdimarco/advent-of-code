def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day6.txt')
SAMPLE = <<~TXT
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
TXT

def find(data, least = false)
  h = Hash.new {|h,k| h[k] = Hash.new(0)}
  data.lines.each do |n|
    n.strip.chars.each_with_index do |c, idx|
      h[idx][c] += 1
    end
  end
  h.keys.sort.map do |k|
    cnts = h[k]  
    v = cnts.keys.sort_by {|kk| cnts[kk]}
    v = v.reverse unless least
    v.first
  end.join
end

assert_equal('easter', find(SAMPLE))
puts "Part 1: #{find(data)}"

assert_equal('advent', find(SAMPLE, true))
puts "Part 2: #{find(data, true)}"