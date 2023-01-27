package day12

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestSum(t *testing.T) {
	cases := []struct {
		given    string
		expected int
	}{{
		given:    "[1,2,3]",
		expected: 6,
	}, {
		given:    `{"a":2,"b":4}`,
		expected: 6,
	}, {
		given:    "[[[3]]]",
		expected: 3,
	}, {
		given:    "{\"a\":{\"b\":4},\"c\":-1}",
		expected: 3,
	}, {
		given:    "[-1,{\"a\":1}]",
		expected: 0,
	}, {
		given:    "{}",
		expected: 0,
	}, {
		given:    "[]",
		expected: 0,
	}}

	for _, tt := range cases {
		t.Run("TestSum", func(t *testing.T) {
			want := tt.expected
			got := Sum(tt.given, false)
			if diff := cmp.Diff(want, got); diff != "" {
				t.Errorf("Sum() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}
func TestPart1(t *testing.T) {
	want := 119433
	got := Sum(utils.InputFileAsString("day12"), false)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	want := 68466
	got := Sum(utils.InputFileAsString("day12"), true)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part2() mismatch (-want +got):\n%s", diff)
	}
}
