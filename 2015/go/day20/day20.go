package day20

import (
	"math"

	"github.com/robdimarco/AdventOfCode/2015/utils"
)

var FactorsCache = make(map[int][]int)

func Factors(n int) []int {
	v, ok := FactorsCache[n]
	if ok {
		return v
	}
	num := n
	factors := []int{1, n}
	p := 2
	for {
		if num <= 1 {
			break
		}
		if num%p == 0 {
			factors = append(append(factors, p), n/p)
		}
		if p > int(math.Sqrt(float64(n))) {
			break
		}
		p += 1
	}
	rv := utils.UniqInt(factors)
	FactorsCache[n] = rv
	return rv
}

func Presents(house int, DeliveriesCache map[int]int, multiple int, stopAt50 bool) int {
	vals := make([]int, 0)

	for _, f := range Factors(house) {
		v, ok := DeliveriesCache[f]
		if !ok || v <= 50 || !stopAt50 {
			vals = append(vals, f)
		}
	}
	for _, n := range vals {
		DeliveriesCache[n] += 1
	}
	return utils.Sum(vals) * multiple
}

func House(target int, multiple int, stopAt50 bool) int {
	DeliveriesCache := make(map[int]int)
	n := 1
	for {
		if Presents(n, DeliveriesCache, multiple, stopAt50) >= target {
			return n
		}
		n += 1
	}
}
