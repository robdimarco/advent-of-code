package day9

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestShortest(t *testing.T) {
	want := 605
	got := Shortest([]string{"London to Dublin = 464", "London to Belfast = 518", "Dublin to Belfast = 141"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Shortest() mismatch (-want +got):\n%s", diff)
	}
}
func TestLongest(t *testing.T) {
	want := 982
	got := Longest([]string{"London to Dublin = 464", "London to Belfast = 518", "Dublin to Belfast = 141"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Longest() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 141
	got := Shortest(utils.InputFileAsLines("day9"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Shortest() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 736
	got := Longest(utils.InputFileAsLines("day9"))
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Longest() mismatch (-want +got):\n%s", diff)
	}
}
func TestMinMax(t *testing.T) {
	WantMin := -5
	WantMax := 20
	GotMin, GotMax := MinMax([]int{-5, 20, 3, 9})
	if diff := cmp.Diff(WantMin, GotMin); diff != "" {
		t.Errorf("Shortest() mismatch (-want +got):\n%s", diff)
	}
	if diff := cmp.Diff(WantMax, GotMax); diff != "" {
		t.Errorf("Shortest() mismatch (-want +got):\n%s", diff)
	}
}

func TestParse(t *testing.T) {
	want := map[string]map[string]int{
		"London":  {"Dublin": 464, "Belfast": 518},
		"Belfast": {"London": 518, "Dublin": 141},
		"Dublin":  {"London": 464, "Belfast": 141},
	}
	got := Parse([]string{"London to Dublin = 464", "London to Belfast = 518", "Dublin to Belfast = 141"})
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Parse() mismatch (-want +got):\n%s", diff)
	}
}
