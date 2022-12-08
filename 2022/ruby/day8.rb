def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read(__FILE__.gsub('.rb', '.txt'))
SAMPLE = <<~TEXT
30373
25512
65332
33549
35390
TEXT

def parse(input)
  trees = {}
  grid = input.lines.each_with_index do |l, y|
    l.strip.chars.each_with_index do |c, x|
      trees[[x,y]] = {height: c.to_i, visible: false}
    end
  end

  (0...grid.size).each do |x|
    (0...grid.size).each do |y|
      tree = trees[[x, y]]
      [[0,1], [1, 0], [-1, 0], [0, -1]].each do |(dx, dy)|
        pos = [x, y]
        loop do
          pos = [pos[0] + dx, pos[1] + dy]
          t_p = trees[pos]
          if t_p.nil?
            tree[:visible] = true
            break
          elsif t_p[:height] >= tree[:height]
            break
          end
        end
      end
    end
  end
  [trees, grid]
end

def run(input)
  trees, _ = parse(input)

  trees.values.count {|t| t[:visible]}
end

assert_equal(21, run(SAMPLE))
puts "Part 1 #{run(DATA)}"

def scenic_score(data)
  trees, grid = parse(data)
  (0...grid.size).each do |x|
    (0...grid.size).each do |y|
      tree = trees[[x, y]]
      cnts = [[0,1], [1, 0], [-1, 0], [0, -1]].map do |(dx, dy)|
        pos = [x, y]
        cnt = 0
        loop do
          pos = [pos[0] + dx, pos[1] + dy]
          t_p = trees[pos]
          if t_p.nil?
            break
          elsif t_p[:height] < tree[:height]
            cnt += 1
          elsif t_p[:height] == tree[:height]
            cnt += 1
            break
          else
            cnt +=1 if dx == 1 || dy == 1
            break
          end
        end
        cnt
      end
      # pp cnts
      tree[:scenic] = cnts.reduce(1, &:*)
    end
  end
  # pp trees
  trees.values.map {|n| n[:scenic]}.max
end
assert_equal(8, scenic_score(SAMPLE))
puts "Part 2 #{scenic_score(DATA)}"
