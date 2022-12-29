package day5

import (
	"testing"

	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestPartOne(t *testing.T) {
	result := NiceCountPartOne(utils.InputFileAsLines("day5"))
	expected := 255
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}

func TestIsNicePartOne(t *testing.T) {
	cases := []struct {
		val      string
		expected bool
	}{{
		val:      "ugknbfddgicrmopn",
		expected: true,
	}, {
		val:      "aaa",
		expected: true,
	}, {
		val:      "jchzalrnumimnmhp",
		expected: false,
	}, {
		val:      "haegwjzuvuyypxyu",
		expected: false,
	}, {
		val:      "dvszwmarrgswjxmb",
		expected: false,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := IsNicePartOne(tt.val)
			if result != tt.expected {
				t.Errorf("expected %t, but got %t", tt.expected, result)
			}
		})
	}
}

func TestIsNicePartTwo(t *testing.T) {
	cases := []struct {
		val      string
		expected bool
	}{{
		val:      "qjhvhtzxzqqjkmpb",
		expected: true,
	}, {
		val:      "xxyxx",
		expected: true,
	}, {
		val:      "uurcxstgmygtbstg",
		expected: false,
	}, {
		val:      "ieodomkazucvgmuy",
		expected: false,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := IsNicePartTwo(tt.val)
			if result != tt.expected {
				t.Errorf("expected %t, but got %t", tt.expected, result)
			}
		})
	}
}

func TestPartTwo(t *testing.T) {
	result := NiceCountPartTwo(utils.InputFileAsLines("day5"))
	expected := 55
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
