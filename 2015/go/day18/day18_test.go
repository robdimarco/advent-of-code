package day18

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestPart1(t *testing.T) {
	want := 1061
	got := FlatSum(Iterate(utils.InputFileAsLines("day18"), 100, false))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	want := 1006
	got := FlatSum(Iterate(utils.InputFileAsLines("day18"), 100, true))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}
}
