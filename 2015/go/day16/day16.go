package day16

import (
	"fmt"
	"regexp"
	"strconv"
)

type Sue struct {
	Idx    int
	Values map[string]int
}

func ParseLine(line string) Sue {
	var idx int

	fmt.Sscanf(line, "Sue %d: %s", &idx)
	prefix := fmt.Sprintf("Sue %d: ", idx)
	prefixLength := len(prefix)
	rest := line[prefixLength:]
	r := regexp.MustCompile(`([a-z]+): (\d+)`)
	matches := r.FindAllStringSubmatch(rest, -1)
	sue := Sue{idx, map[string]int{}}
	for _, m := range matches {
		sue.Values[m[1]], _ = strconv.Atoi(m[2])
	}

	return sue
}

func Matches(sue Sue, tickerTape map[string]int, useRange bool) bool {
	for k, v := range tickerTape {
		sv, ok := sue.Values[k]
		if !ok {
			continue
		}
		if v != sv {
			if useRange {
				if k == "cats" || k == "trees" {
					if sv <= v {
						return false
					}
				} else if k == "pomeranians" || k == "goldfish" {
					if sv >= v {
						return false
					}
				} else {
					return false
				}
			} else {
				return false
			}
		}
	}
	return true
}

func FindSue(input []string, tickerTape map[string]int, useRange bool) int {
	for _, line := range input {
		sue := ParseLine(line)
		if Matches(sue, tickerTape, useRange) {
			return sue.Idx
		}
	}
	return -1
}
