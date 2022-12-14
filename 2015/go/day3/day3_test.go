package day3

import (
	"testing"

	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestDeliveryCount(t *testing.T) {
	cases := []struct {
		val      string
		expected int
		elves    int
	}{{
		val:      ">",
		elves:    1,
		expected: 2,
	}, {
		val:      "^>v<",
		elves:    1,
		expected: 4,
	}, {
		val:      "^v^v^v^v^v",
		elves:    1,
		expected: 2,
	}, {
		val:      ">",
		elves:    2,
		expected: 3,
	}, {
		val:      "^>v<",
		elves:    2,
		expected: 3,
	}, {
		val:      "^v^v^v^v^v",
		elves:    2,
		expected: 11,
	}}

	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := DeliveryCount(Params{input: tt.val, elves: tt.elves})
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestPart1(t *testing.T) {
	data := utils.InputFileAsString("day3")
	expected := 2081
	result := DeliveryCount(Params{input: data, elves: 1})
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
func TestPart2(t *testing.T) {
	data := utils.InputFileAsString("day3")
	expected := 2341
	result := DeliveryCount(Params{input: data, elves: 2})
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
