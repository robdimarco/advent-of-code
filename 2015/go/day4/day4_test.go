package day4

import (
	"testing"
)

func TestLowestPositive(t *testing.T) {
	cases := []struct {
		val      string
		expected int
	}{{
		val:      "abcdef",
		expected: 609043,
	}, {
		val:      "pqrstuv",
		expected: 1048970,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := LowestPositive(tt.val)
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestPart1(t *testing.T) {
	data := "iwrupvqb"
	expected := 346386
	result := LowestPositive(data)
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
