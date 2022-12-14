package day1

import (
	"os"
	"testing"
)

func TestFloor(t *testing.T) {
	cases := []struct {
		val      string
		expected int
	}{
		{
			val:      "(())",
			expected: 0,
		},
		{
			val:      "()()",
			expected: 0,
		},
		{
			val:      "(((",
			expected: 3,
		},
		{
			val:      "(()(()(",
			expected: 3,
		},
		{
			val:      "))(((((",
			expected: 3,
		},
		{
			val:      "))(((((",
			expected: 3,
		},
		{
			val:      "())",
			expected: -1,
		},
		{
			val:      "))(",
			expected: -1,
		},
		{
			val:      ")())())",
			expected: -3,
		},
	}
	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := floor(tt.val)
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestBasement(t *testing.T) {
	cases := []struct {
		val      string
		expected int
	}{
		{
			val:      ")",
			expected: 1,
		},
		{
			val:      "()())",
			expected: 5,
		},
	}
	for _, tt := range cases {
		t.Run("Test", func(t *testing.T) {
			result := basement(tt.val)
			if result != tt.expected {
				t.Errorf("expected %d, but got %d", tt.expected, result)
			}
		})
	}
}

func TestPart1(t *testing.T) {
	dat, _ := os.ReadFile("../../ruby/day1.txt")
	expected := 232
	result := floor(string(dat))
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}

func TestPart2(t *testing.T) {
	dat, _ := os.ReadFile("../../ruby/day1.txt")
	expected := 1783
	result := basement(string(dat))
	if result != expected {
		t.Errorf("expected %d, but got %d", expected, result)
	}
}
