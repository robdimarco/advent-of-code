package day16

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

var TickerTape = map[string]int{
	"children":    3,
	"cats":        7,
	"samoyeds":    2,
	"pomeranians": 3,
	"akitas":      0,
	"vizslas":     0,
	"goldfish":    5,
	"trees":       3,
	"cars":        2,
	"perfumes":    1,
}

func TestParseLine(t *testing.T) {
	want := Sue{1, map[string]int{"goldfish": 9, "cars": 0, "samoyeds": 9}}
	got := ParseLine("Sue 1: goldfish: 9, cars: 0, samoyeds: 9")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 40
	got := FindSue(utils.InputFileAsLines("day16"), TickerTape, false)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 241
	got := FindSue(utils.InputFileAsLines("day16"), TickerTape, true)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part2() mismatch (-want +got):\n%s", diff)
	}
}
