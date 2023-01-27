package day17

import (
	"strconv"

	combinations "github.com/mxschmitt/golang-combinations"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func Containers(input []string) []int {
	containers := make([]int, len(input))
	for idx, line := range input {
		containers[idx], _ = strconv.Atoi(line)
	}
	return containers
}

func Matches(input []string, amt int) int {
	containers := Containers(input)
	matches := 0
	for idx := 1; idx <= len(input); idx++ {
		combos := combinations.Combinations(containers, idx)
		for _, combo := range combos {
			if utils.Sum(combo) == amt {
				matches++
			}
		}
	}
	return matches
}

func MinMatches(input []string, amt int) int {
	containers := Containers(input)
	matches := make([][]int, 0)
	for idx := 1; idx <= len(input); idx++ {
		combos := combinations.Combinations(containers, idx)
		for _, combo := range combos {
			if utils.Sum(combo) == amt {
				matches = append(matches, combo)
			}
		}
	}
	minMatchNum := len(matches[0])
	for _, match := range matches {
		if minMatchNum > len(match) {
			minMatchNum = len(match)
		}
	}
	minMatchCount := 0
	for _, match := range matches {
		if len(match) == minMatchNum {
			minMatchCount++
		}
	}
	return minMatchCount
}
