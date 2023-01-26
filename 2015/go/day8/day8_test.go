package day8

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestPart1(t *testing.T) {
	want := 12
	got := Part1([]string{"\"\"", "\"abc\"", "\"aaa\\\"aaa\"", "\"\\x27\""})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart1Actual(t *testing.T) {
	want := 1371
	got := Part1(utils.InputFileAsLines("day8"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}

func TestEffectiveCharCount(t *testing.T) {
	cases := []struct {
		given    string
		expected int
	}{{
		given:    "\"\"",
		expected: 0,
	}, {
		given:    "\"abc\"",
		expected: 3,
	}, {
		given:    "\"aaa\\\"aaa\"",
		expected: 7,
	}, {
		given:    "\"\\x27\"",
		expected: 1,
	}}

	for _, tt := range cases {
		t.Run("TestEffectiveCharCount", func(t *testing.T) {
			want := tt.expected
			got := EffectiveCharCount(tt.given)
			if diff := cmp.Diff(want, got); diff != "" {
				t.Errorf("EffectiveCharCount() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}
