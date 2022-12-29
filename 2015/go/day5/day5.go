package day5

import (
	"fmt"
	"regexp"
	"strings"
)

func Doubles() [26]string {
	doubles := [26]string{}
	for i := 0; i < 26; i += 1 {
		ch := fmt.Sprintf("%c", int('a')+i)
		doubles[i] = string(ch) + string(ch)
	}
	return doubles
}
func IsNicePartOne(input string) bool {
	vowels, _ := regexp.Match(`[aeiou].*[aeiou].*[aeiou]`, []byte(input))
	hasDouble := false
	doubles := Doubles()
	badStrings := [4]string{"ab", "cd", "pq", "xy"}
	for _, bad := range badStrings {
		if strings.Contains(input, bad) {
			return false
		}
	}

	for _, double := range doubles {
		hasDouble = hasDouble || strings.Contains(input, double)
	}

	return vowels && hasDouble
}

func NiceCountPartOne(lines []string) int {
	rv := 0
	for _, line := range lines {
		if IsNicePartOne(line) {
			rv += 1
		}
	}
	return rv
}

func TwoLetterOverlap(str string) bool {
	return len(str) > 2 && (strings.Contains(str[2:], str[0:2]) || TwoLetterOverlap(str[1:]))
}

func OneLetterGap(str string) bool {
	return len(str) > 2 && (str[0] == str[2] || OneLetterGap(str[1:]))
}

func IsNicePartTwo(str string) bool {
	return TwoLetterOverlap(str) && OneLetterGap(str)
}

func NiceCountPartTwo(lines []string) int {
	rv := 0
	for _, line := range lines {
		if IsNicePartTwo(line) {
			rv += 1
		}
	}
	return rv
}
