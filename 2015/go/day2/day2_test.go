package day2

import (
	"testing"

	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestBoxSa(t *testing.T) {
	cases := []struct {
		val      string
		expected int
	}{{
		val:      "2x3x4",
		expected: 58,
	}, {
		val:      "1x1x10",
		expected: 43,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := BoxSA(tt.val)
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestRibbonLength(t *testing.T) {
	cases := []struct {
		val      string
		expected int
	}{{
		val:      "2x3x4",
		expected: 34,
	}, {
		val:      "1x1x10",
		expected: 14,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := RibbonLength(tt.val)
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestPart1(t *testing.T) {
	lines := utils.InputFileAsLines("day2")
	expected := 1588178
	result := 0
	for _, line := range lines {
		result += BoxSA(line)
	}
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}

func TestPart2(t *testing.T) {
	lines := utils.InputFileAsLines("day2")
	expected := 3783758
	result := 0
	for _, line := range lines {
		result += RibbonLength(line)
	}
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
