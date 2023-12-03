sample =<<TXT.lines
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+
TXT

def part1(lines)
  col = (0..lines[0].size).detect {|n| lines[0][n].strip != "" }
  dir = {row: 1, col: 0}
  pos = {row: 0, col: col}
  steps = 1

  rv = ""
  loop do
    # puts "At #{pos} moving #{dir}"
    n_row = pos[:row] + dir[:row]
    n_col = pos[:col] + dir[:col]
    if n_row < 0 || n_row >= lines.size || n_col < 0 || n_col >= lines[n_row].size
      n_char = ""
    else
      n_char = lines[n_row][n_col]
    end

    if n_char.strip == ""
      is_set = false
      # Need to change direction
      [-1, 0, 1].each do |drow|
        [-1, 0, 1].each do |dcol|
          next if is_set
          next if (dcol == 0 && drow == 0)
          next if dcol * -1 == dir[:col] && drow * -1 == dir[:row]
          # puts "#{dcol * -1} == #{dir[:col]} && #{drow * -1} == #{dir[:row]}"
          n_row = pos[:row] + drow
          n_col = pos[:col] + dcol
          next if n_row < 0 || n_row >= lines.size || n_col < 0 || n_col >= lines[n_row].size
          # puts "Checking #{lines[n_row][n_col]}"
          if lines[n_row][n_col].strip != ""
            dir = {row: drow, col: dcol}
            is_set = true
          end
        end
      end
      break unless is_set
    elsif n_char =~ /[a-z]/i
      rv = "#{rv}#{n_char}"
      pos = {row: n_row, col: n_col}
      steps += 1
    else
      pos = {row: n_row, col: n_col}
      steps += 1
    end
  end
  [rv, steps].join(", ")
end

puts part1(sample)
puts part1(File.read("day19.txt").lines)