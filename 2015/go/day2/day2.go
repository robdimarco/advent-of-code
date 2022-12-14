package day2

import (
	"math"
	"strconv"
	"strings"
)

func BoxSA(dims string) int {
	split := strings.Split(dims, "x")
	w, _ := strconv.Atoi(split[0])
	l, _ := strconv.Atoi(split[1])
	h, _ := strconv.Atoi(split[2])
	return 2*l*w + 2*w*h + 2*h*l + int(math.Min(math.Min(float64(w*l), float64(l*h)), float64(w*h)))
}

func RibbonLength(dims string) int {
	split := strings.Split(dims, "x")
	w, _ := strconv.Atoi(split[0])
	l, _ := strconv.Atoi(split[1])
	h, _ := strconv.Atoi(split[2])
	return l*w*h + int(
		math.Min(
			math.Min(float64(2*w+2*l), float64(2*l+2*h)), float64(2*w+2*h)))
}
