package day1

func floor(input string) int {
	var floor = 0
	for i := 0; i < len(input); i++ {
		var c = input[i]
		if c == '(' {
			floor = floor + 1
		} else if c == ')' {
			floor = floor - 1
		}
	}
	return floor
}

func basement(input string) int {
	var floor = 0
	for i := 0; i < len(input); i++ {
		var c = input[i]
		if c == '(' {
			floor = floor + 1
		} else if c == ')' {
			floor = floor - 1
		}
		if floor == -1 {
			return i + 1
		}
	}
	return floor
}
