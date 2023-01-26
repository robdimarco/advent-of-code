package day7

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestPart1(t *testing.T) {
	commands := []string{"123 -> x", "456 -> y", "x AND y -> d", "x OR y -> e", "x LSHIFT 2 -> f", "y RSHIFT 2 -> g", "NOT x -> h",
		"NOT y -> i"}
	want := map[string]uint16{"d": 72, "e": 507, "f": 492, "g": 114, "h": 65412, "i": 65079, "x": 123, "y": 456}
	got := Part1(commands)

	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}
}
func TestPart1Actual(t *testing.T) {
	got := Part1(utils.InputFileAsLines("day7"))["a"]
	want := uint16(46065)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Part1Actual() mismatch (-want +got):\n%s", diff)
	}
}
func TestApplyCommand(t *testing.T) {

	want := map[string]uint16{"a": 5}
	got := map[string]uint16{}
	ApplyCommand(got, "5 -> a")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}

	ApplyCommand(got, "7 -> b")
	want = map[string]uint16{"a": 5, "b": 7}
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}

	ApplyCommand(got, "b -> c")
	want = map[string]uint16{"a": 5, "b": 7, "c": 7}
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}
}

func TestGetValue(t *testing.T) {
	hash := make(map[string]uint16)
	hash["a"] = 5
	var want, got uint16

	want = 5
	got, _ = GetValue(hash, "a")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}
	want = 99
	got, _ = GetValue(hash, "99")
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("GetValue() mismatch (-want +got):\n%s", diff)
	}
}
