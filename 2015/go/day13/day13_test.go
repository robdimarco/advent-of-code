package day13

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestParseLine(t *testing.T) {
	want := Instruction{"Alice", "Bob", 54}
	got := ParseLine("Alice would gain 54 happiness units by sitting next to Bob.")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
	want = Instruction{"Alice", "Bob", -2}
	got = ParseLine("Alice would lose 2 happiness units by sitting next to Bob.")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}

func TestTotalChange(t *testing.T) {
	sample := []string{
		`Alice would gain 54 happiness units by sitting next to Bob.`,
		`Alice would lose 79 happiness units by sitting next to Carol.`,
		`Alice would lose 2 happiness units by sitting next to David.`,
		`Bob would gain 83 happiness units by sitting next to Alice.`,
		`Bob would lose 7 happiness units by sitting next to Carol.`,
		`Bob would lose 63 happiness units by sitting next to David.`,
		`Carol would lose 62 happiness units by sitting next to Alice.`,
		`Carol would gain 60 happiness units by sitting next to Bob.`,
		`Carol would gain 55 happiness units by sitting next to David.`,
		`David would gain 46 happiness units by sitting next to Alice.`,
		`David would lose 7 happiness units by sitting next to Bob.`,
		`David would gain 41 happiness units by sitting next to Carol.`,
	}
	want := 330
	got := TotalChange(sample, false)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 618
	got := TotalChange(utils.InputFileAsLines("day13"), false)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("TestPart1() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 601
	got := TotalChange(utils.InputFileAsLines("day13"), true)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("TestPart2() mismatch (-want +got):\n%s", diff)
	}
}
