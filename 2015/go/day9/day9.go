package day9

import "fmt"

func Shortest(input []string) int {
	return ShortLong(input, "min")
}

func Longest(input []string) int {
	return ShortLong(input, "max")
}

func ShortLong(Input []string, LookupType string) int {
	Routes := Parse(Input)
	Destinations := make([]string, 0)

	for k := range Routes {
		Destinations = append(Destinations, k)
	}
	Distances := make([]int, len(Destinations))
	for Idx, Start := range Destinations {
		Distances[Idx] = Distance(Routes, Start, OtherThan(Destinations, Start), LookupType)
	}
	min, max := MinMax(Distances)
	if LookupType == "min" {
		return min
	} else {
		return max
	}
}

func OtherThan(All []string, Minus string) []string {
	Copy := make([]string, len(All))
	copy(Copy, All)
	for Idx, Val := range Copy {
		if Val == Minus {
			return append(Copy[:Idx], Copy[Idx+1:]...)
		}
	}
	return Copy
}

func Distance(Routes map[string]map[string]int, Start string, Destinations []string, LookupType string) int {
	if len(Destinations) == 1 {
		return Routes[Start][Destinations[0]]
	}
	Distances := make([]int, 0)
	for _, Destination := range Destinations {
		OtherDestinations := OtherThan(Destinations, Destination)
		Distances = append(Distances, Routes[Start][Destination]+Distance(Routes, Destination, OtherDestinations, LookupType))
	}
	min, max := MinMax(Distances)
	if LookupType == "min" {
		return min
	} else {
		return max
	}
}

func MinMax(vals []int) (int, int) {
	min := vals[0]
	max := vals[0]
	for _, v := range vals {
		if v < min {
			min = v
		}
		if v > max {
			max = v
		}
	}
	return min, max
}

func Parse(input []string) map[string]map[string]int {
	rv := map[string]map[string]int{}

	for _, line := range input {
		var from, to string
		var dist int
		fmt.Sscanf(line, "%s to %s = %d", &from, &to, &dist)

		_, ok := rv[from]
		if !ok {
			rv[from] = map[string]int{}
		}
		_, ok = rv[to]
		if !ok {
			rv[to] = map[string]int{}
		}

		rv[from][to] = dist
		rv[to][from] = dist
	}
	return rv
}
