package day20

import (
	"sort"
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestFormat(t *testing.T) {
	cases := []struct {
		input    int
		expected []int
	}{{
		input:    6,
		expected: []int{1, 2, 3, 6},
	}, {
		input:    9,
		expected: []int{1, 3, 9},
	}, {
		input:    12,
		expected: []int{1, 2, 3, 4, 6, 12},
	}, {
		input:    24,
		expected: []int{1, 2, 3, 4, 6, 8, 12, 24},
	}, {
		input:    17,
		expected: []int{1, 17},
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			expected := tt.expected
			sort.Ints(expected)
			got := Factors(tt.input)
			sort.Ints(got)

			if diff := cmp.Diff(expected, got); diff != "" {
				t.Errorf("Factors() mismatch (-want +got):\n%s", diff)
			}
		})
	}
}

func TestHouse(t *testing.T) {
	expected := 1
	got := House(2, 10, false)
	if diff := cmp.Diff(expected, got); diff != "" {
		t.Errorf("House() mismatch (-want +got):\n%s", diff)
	}
	expected = 6
	got = House(100, 10, false)
	if diff := cmp.Diff(expected, got); diff != "" {
		t.Errorf("House() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	expected := 665280
	got := House(29000000, 10, false)
	if diff := cmp.Diff(expected, got); diff != "" {
		t.Errorf("House() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	expected := 705600
	got := House(29000000, 11, true)
	if diff := cmp.Diff(expected, got); diff != "" {
		t.Errorf("House() mismatch (-want +got):\n%s", diff)
	}
}
