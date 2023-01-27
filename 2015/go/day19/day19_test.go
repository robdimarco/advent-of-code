package day19

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

var SAMPLE = []string{
	`H => HO`,
	`H => OH`,
	`O => HH`,
	"",
	"HOH",
}

func TestDistinctCount(t *testing.T) {
	want := 4
	got := DistinctCount(SAMPLE)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}

}
func TestPart1(t *testing.T) {
	want := 518
	got := DistinctCount(utils.InputFileAsLines("day19"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}
}

func TestGenerate(t *testing.T) {
	want := 3
	got := Generate([]string{
		"e => H", "e => O", "H => HO", "H => OH", "O => HH", "", "HOH",
	})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Matches() mismatch (-want +got):\n%s", diff)
	}

	want = 6
	got = Generate([]string{
		"e => H", "e => O", "H => HO", "H => OH", "O => HH", "", "HOHOHO",
	})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Generate() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	want := 200
	got := Generate(utils.InputFileAsLines("day19"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Generate() mismatch (-want +got):\n%s", diff)
	}
}
