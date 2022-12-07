def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
DATA = File.read("day7.txt")
SAMPLE = <<~TEXT
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
TEXT
AOCFile = Struct.new(:size, :name)
AOCDir = Struct.new(:name, :contents) do 
  def size
    contents.sum(&:size)
  end

  def files
    contents.select {|d| d.is_a?(AOCFile)}
  end

  def dirs
    contents.select {|d| d.is_a?(AOCDir)}
  end

  def find(name)
    contents.find {|i| i.name == name}
  end

  def all_dirs
    dirs.reduce([self]) do |acc, d|
      acc += d.all_dirs
      acc
    end
  end
end

def parse_input(input)
  root = AOCDir.new('/', [])
  dir_history = []

  input.lines.each do |l|
    # require 'debug'; binding.break
    if l.start_with?('$')
      _, cmd, args = l.split(/\s+/)
      if cmd == 'cd'
        case args
        when '/'
          dir_history.push(root)
        when '..'
          dir_history = dir_history[0..-2]
        else
          dir = dir_history[-1].find(args)
          dir_history.push(dir) if dir
        end
      end
    else
      tokens = l.split(/\s+/)
      dir = dir_history[-1]
      if tokens[0] == 'dir'
        dir.contents.push(AOCDir.new(tokens[1], []))
      else
        dir.contents.push(AOCFile.new(tokens[0].to_i, tokens[1]))
      end
    end
  end
  root
end

def file_size(input)
  dir = parse_input(input)
  # pp dir
  dir.all_dirs.select {|d| d.size < 100_000}.sum(&:size)
end

assert_equal(95437, file_size(SAMPLE))
puts "Part 1 #{file_size(DATA)}"

def smallest(input)
  dir = parse_input(input)
  space = 70000000
  unused = space - dir.size
  needed = 30000000 - unused
  dir.all_dirs.map(&:size).select {|n| n >= needed}.sort.first
end

assert_equal(24933642, smallest(SAMPLE))
puts "Part 2 #{smallest(DATA)}"