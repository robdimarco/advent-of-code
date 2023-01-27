package day10

import (
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestPart1(t *testing.T) {
	want := 252594
	got := Part1("1113222113")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	want := 3579328
	got := Part2("1113222113")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part2() mismatch (-want +got):\n%s", diff)
	}
}

func TestLookAndSay(t *testing.T) {
	cases := []struct {
		given    string
		expected string
	}{{
		given:    "1",
		expected: "11",
	}, {
		given:    "11",
		expected: "21",
	}, {
		given:    "21",
		expected: "1211",
	}, {
		given:    "1211",
		expected: "111221",
	}, {
		given:    "111221",
		expected: "312211",
	}}

	for _, tt := range cases {
		t.Run("TestLookAndSay", func(t *testing.T) {
			want := tt.expected
			got := LookAndSay(tt.given)
			if diff := cmp.Diff(want, got); diff != "" {
				t.Errorf("LookAndSay() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}
