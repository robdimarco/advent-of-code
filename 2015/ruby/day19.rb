def assert_equal(expected, actual, str="")
  raise "Expected #{expected} but got #{actual}. #{str}" unless expected == actual
end
data = File.read('day19.txt')

sample = <<~TXT
H => HO
H => OH
O => HH

HOH
TXT

def parse(data)
  lines = data.lines.map(&:strip)
  molecule = lines.pop
  lines.pop
  rules = lines.map do |l|
    l.split(' => ')
  end
  [molecule, rules]
end

def possibles_from_molecule(molecule, rules)
  possibles = []
  atoms = molecule.scan(/[A-Z][a-z]?/)

  atoms.each_with_index do |atom, idx|
    rules.each do |src, result|
      if atom == src
        possibles << [atoms[0...idx].join, result, atoms[(idx+1)..-1].join].join
      end
    end
  end
  possibles
end

def distinct_count(data)
  molecule, rules = parse(data)
  possibles_from_molecule(molecule, rules).uniq.size
end
# assert_equal(4, distinct_count(sample))
# puts "Part 1: #{distinct_count(data)}"


sample_2 = <<~TXT
e => H
e => O
H => HO
H => OH
O => HH

HOH
TXT
sample_3 = <<~TXT
e => H
e => O
H => HO
H => OH
O => HH

HOHOHO
TXT

def generate(data)
  molecule, rules = parse(data)
  rules = rules.sort_by {|r| r[1].size}.reverse
  count = 0
  # molecules_to_break_down = [[0, target_molecule]]
  while molecule != 'e' do
    rules.each do |rule|
      if molecule.include?(rule[1])
        molecule = molecule.sub(rule[1], rule[0])
        count +=1
        puts molecule
        break;
      end
    end
  end
  count
  # checked = []
  # steps = []
  # cache_hits = 0
  # # puts "rules #{rules.inspect}"

  # while molecules_to_break_down.any?
  #   puts "Need to check #{molecules_to_break_down.size}: first #{molecules_to_break_down.first.first}, last #{molecules_to_break_down.last.first} checked: #{checked.size} #{cache_hits}" if rand < 0.01
  #   step, molecule = molecules_to_break_down.shift
  #   # puts "Checking #{molecule} in step #{step}"
  #   if molecule == 'e'
  #     steps.push(step)
  #     # puts "Eureka #{step}"
  #     break;
  #   end

  #   atoms = molecule.scan(/[A-Z][a-z]?/)
  #   rules.each do |src, result|
  #     next unless molecule.include?(result)
  #     result_atoms = result.scan(/[A-Z][a-z]?/)
  #     if src == 'e' and result != molecule
  #       next
  #     end

  #     atoms.each_with_index do |_, idx|
  #       section = atoms.slice(idx, result_atoms.size)
  #       if section == result_atoms
  #         new_molecule = atoms[0...idx].join << src 
  #         suffix = atoms[idx + result_atoms.size..-1]
  #         new_molecule << suffix.join if suffix
  #         unless checked.include?(new_molecule)
  #           # puts "queuing #{new_molecule}"
  #           molecules_to_break_down.unshift(
  #             [step + 1, new_molecule]
  #           )
  #           checked.push(new_molecule)
  #         else 
  #           cache_hits += 1
  #         end
  #       end
  #     end
  #   end
  # end

  # steps.min
end

assert_equal(3, generate(sample_2))
assert_equal(6, generate(sample_3))
puts "Part 2: #{generate(data)}"