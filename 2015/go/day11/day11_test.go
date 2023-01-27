package day11

import (
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestValidPassword(t *testing.T) {
	cases := []struct {
		given    string
		expected bool
	}{{
		given:    "hijklmmn",
		expected: false,
	}, {
		given:    "abbceffg",
		expected: false,
	}, {
		given:    "abbcegjk",
		expected: false,
	}, {
		given:    "abcdffaa",
		expected: true,
	}, {
		given:    "ghjaabcc",
		expected: true,
	}}

	for _, tt := range cases {
		t.Run("TestValidPassword", func(t *testing.T) {
			want := tt.expected
			got := ValidPassword(tt.given)
			if diff := cmp.Diff(want, got); diff != "" {
				t.Errorf("ValidPassword() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}
func TestIncrementPassword(t *testing.T) {
	cases := []struct {
		given    string
		expected string
	}{{
		given:    "ghijklmn",
		expected: "ghjaabcc",
	}, {
		given:    "abcdefgh",
		expected: "abcdffaa",
	}}

	for _, tt := range cases {
		t.Run("TestIncrementPassword", func(t *testing.T) {
			want := tt.expected
			got := IncrementPassword(tt.given)
			if diff := cmp.Diff(want, got); diff != "" {
				t.Errorf("IncrementPassword() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}
func TestPart1(t *testing.T) {
	want := "hxbxxyzz"
	got := IncrementPassword("hxbxwxba")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart2(t *testing.T) {
	want := "hxcaabcc"
	got := IncrementPassword(IncrementPassword("hxbxwxba"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part2() mismatch (-want +got):\n%s", diff)
	}
}
