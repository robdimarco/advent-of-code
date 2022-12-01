data = File.read('day1.txt')
floor = 0
data.chars.each_with_index do |c, i| 
	if c == '('; 
		floor +=1; 
	elsif c == ')'; 
		floor -= 1; 
	end
  if floor == -1; puts i+1; end
end
puts floor