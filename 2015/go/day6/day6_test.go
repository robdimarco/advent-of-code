package day6

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestGetInstruction(t *testing.T) {
	cases := []struct {
		given    string
		expected Instruction
	}{{
		given:    "turn on 489,959 through 759,964",
		expected: Instruction{Cmd: "on", StartPos: [2]int{489, 959}, EndPos: [2]int{759, 964}},
	}, {
		given:    "turn off 820,516 through 871,914",
		expected: Instruction{Cmd: "off", StartPos: [2]int{820, 516}, EndPos: [2]int{871, 914}},
	}, {
		given:    "toggle 0,0 through 999,0",
		expected: Instruction{Cmd: "toggle", StartPos: [2]int{0, 0}, EndPos: [2]int{999, 0}},
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := GetInstruction(tt.given)
			if result != tt.expected {
				t.Errorf("expected %#v, but got %#v", tt.expected, result)
			}
		})
	}
}

func TestGetInstructions(t *testing.T) {
	cases := []struct {
		given    []string
		expected []Instruction
	}{{
		given:    []string{"turn on 489,959 through 759,964", "turn off 820,516 through 871,914"},
		expected: []Instruction{{Cmd: "on", StartPos: [2]int{489, 959}, EndPos: [2]int{759, 964}}, {Cmd: "off", StartPos: [2]int{820, 516}, EndPos: [2]int{871, 914}}},
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			got := GetInstructions(tt.given)
			if diff := cmp.Diff(tt.expected, got); diff != "" {
				t.Errorf("GetInstructions() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}

func TestPart1(t *testing.T) {
	var want, got int
	want = 0
	got = Part1([]string{})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}

	want = 4
	got = Part1([]string{"turn on 499,499 through 500,500"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}

	want = 1_000_000
	got = Part1([]string{"turn on 0,0 through 999,999"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}

	want = 999_996
	got = Part1([]string{"turn on 0,0 through 999,999", "turn off 499,499 through 500,500"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}

	want = 569999
	got = Part1(utils.InputFileAsLines("day6"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	var want, got int

	want = 17836115
	got = Part2(utils.InputFileAsLines("day6"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
