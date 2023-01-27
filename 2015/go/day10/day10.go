package day10

import "fmt"

func LookAndSay(input string) string {
	rv := make([]byte, 0)
	LastChar := input[0]
	Count := 1
	for Idx := 1; Idx < len(input); Idx++ {
		c := input[Idx]
		if LastChar == c {
			Count++
		} else {
			rv = append(rv, []byte(fmt.Sprintf("%d", Count))...)
			rv = append(rv, LastChar)
			LastChar = c
			Count = 1
		}
	}
	rv = append(rv, []byte(fmt.Sprintf("%d", Count))...)
	rv = append(rv, LastChar)
	return string(rv)
}

func Part1(input string) int {
	for i := 0; i < 40; i++ {
		input = LookAndSay(input)
	}
	return len(input)
}

func Part2(input string) int {
	for i := 0; i < 50; i++ {
		input = LookAndSay(input)
	}
	return len(input)
}
