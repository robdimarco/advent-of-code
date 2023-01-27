package day15

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestAmounts(t *testing.T) {
	want := [][]int{{100}}
	got := Amounts(1, 100)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Amounts() mismatch (-want +got):\n%s", diff)
	}
	want = [][]int{{1, 0}, {0, 1}}
	got = Amounts(2, 1)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Amounts() mismatch (-want +got):\n%s", diff)
	}
	want = [][]int{{2, 0}, {1, 1}, {0, 2}}
	got = Amounts(2, 2)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Amounts() mismatch (-want +got):\n%s", diff)
	}
	want = [][]int{{2, 0, 0}, {1, 1, 0}, {0, 2, 0}, {1, 0, 1}, {0, 1, 1}, {0, 0, 2}}
	got = Amounts(3, 2)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Amounts() mismatch (-want +got):\n%s", diff)
	}
}

func TestParseLine(t *testing.T) {
	want := Ingredient{"Butterscotch", -1, -2, 6, 3, 8}
	got := ParseLine("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}

func TestHighestScore(t *testing.T) {

	sample := []string{
		`Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8`,
		`Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3`,
	}
	want := 62842880
	got := HighestScore(sample, -1)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("HighestScore() mismatch (-want +got):\n%s", diff)
	}
	want = 57600000
	got = HighestScore(sample, 500)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("HighestScore() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 13882464
	got := HighestScore(utils.InputFileAsLines("day15"), -1)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 11171160
	got := HighestScore(utils.InputFileAsLines("day15"), 500)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part2() mismatch (-want +got):\n%s", diff)
	}
}
