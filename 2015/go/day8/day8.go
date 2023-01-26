package day8

func Part1(lines []string) int {
	var Cnt, CharCnt int
	for _, line := range lines {
		Cnt += len(line)
		CharCnt += EffectiveCharCount(line)
	}
	return Cnt - CharCnt
}

func EffectiveCharCount(s string) int {
	pos := 0
	sum := 0
	for {
		if pos >= len(s) {
			break
		}
		c := s[pos]

		if c == '"' {
			pos++
			continue
		}
		if c == '\\' {
			pos++
			c = s[pos]
			if c == 'x' {
				pos += 2
			}
		}
		sum++
		pos++
	}
	return sum
}
