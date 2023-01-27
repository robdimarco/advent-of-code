package day13

import (
	"fmt"
	"strings"
)

type Instruction struct {
	To     string
	From   string
	Amount int
}

func ParseLine(line string) Instruction {
	var a, b, gl string
	var value int
	fmt.Sscanf(line, "%s would %s %d happiness units by sitting next to %s", &a, &gl, &value, &b)
	if gl == "lose" {
		value *= -1
	}
	b = strings.TrimSuffix(b, ".")
	return Instruction{a, b, value}
}

func Combos(Input []string) map[string]map[string]int {
	rv := make(map[string]map[string]int)
	for _, line := range Input {
		i := ParseLine(line)
		if _, ok := rv[i.From]; !ok {
			rv[i.From] = make(map[string]int)
		}
		rv[i.From][i.To] = i.Amount
	}

	return rv
}

func TotalChange(Input []string, IncludeMe bool) int {
	combos := Combos(Input)
	names := make([]string, 0)
	for k := range combos {
		names = append(names, k)
	}
	if IncludeMe {
		names = append(names, "***ME***")
	}
	max := 0
	for _, order := range Permutations(names) {

		i := 0
		sum := 0
		for i < len(order) {
			other := i + 1
			if other == len(order) {
				other = 0
			}

			v := combos[order[i]][order[other]] + combos[order[other]][order[i]]
			sum += v
			i += 1
		}
		if sum > max {
			max = sum
		}
	}
	return max
}

func Permutations(arr []string) [][]string {
	var helper func([]string, int)
	res := [][]string{}

	helper = func(arr []string, n int) {
		if n == 1 {
			tmp := make([]string, len(arr))
			copy(tmp, arr)
			res = append(res, tmp)
		} else {
			for i := 0; i < n; i++ {
				helper(arr, n-1)
				if n%2 == 1 {
					tmp := arr[i]
					arr[i] = arr[n-1]
					arr[n-1] = tmp
				} else {
					tmp := arr[0]
					arr[0] = arr[n-1]
					arr[n-1] = tmp
				}
			}
		}
	}
	helper(arr, len(arr))
	return res
}
