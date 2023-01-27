package day17

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

var SAMPLE = []string{"20", "15", "10", "5", "5"}

func TestMatches(t *testing.T) {
	want := 4
	got := Matches(SAMPLE, 25)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 4372
	got := Matches(utils.InputFileAsLines("day17"), 150)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}
}
func TestMinMatches(t *testing.T) {
	want := 3
	got := MinMatches(SAMPLE, 25)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("MinMatches() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 4
	got := MinMatches(utils.InputFileAsLines("day17"), 150)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("MinMatches() mismatch (-want +got):\n%s", diff)
	}
}
