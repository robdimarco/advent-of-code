package day14

import (
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/robdimarco/AdventOfCode/2015/utils"
)

func TestDistance(t *testing.T) {
	want := 14
	got := Distance(Reindeer{"Comet", 14, 10, 127}, 1)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
	want = 140
	got = Distance(Reindeer{"Comet", 14, 10, 127}, 10)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
	want = 1120
	got = Distance(Reindeer{"Comet", 14, 10, 127}, 1_000)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
	want = 1056
	got = Distance(Reindeer{"Dancer", 16, 11, 162}, 1_000)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}
func TestRace(t *testing.T) {
	want := 1120
	got := Race(
		[]string{
			`Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.`,
			`Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.`,
		}, 1_000)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Race() mismatch (-want +got):\n%s", diff)
	}
}
func TestPoints(t *testing.T) {
	want := 689
	got := Points(
		[]string{
			`Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.`,
			`Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.`,
		}, 1_000)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("Points() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart1(t *testing.T) {
	want := 2696
	got := Race(utils.InputFileAsLines("day14"), 2_503)
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}
}

func TestPart2(t *testing.T) {
	want := 1084
	got := Points(utils.InputFileAsLines("day14"), 2_503)

	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("ParseLine() mismatch (-want +got):\n%s", diff)
	}

}
