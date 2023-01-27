package day21

import (
	"testing"

	"github.com/google/go-cmp/cmp"
)

func TestPartOneAndTwo(t *testing.T) {

	expectedMost := 91
	expectedLeast := 158
	gotMost, gotLeast := Simulate(10_000)
	if diff := cmp.Diff(expectedMost, gotMost); diff != "" {
		t.Errorf("SimulateMost() mismatch (-want +got):\n%s", diff)
	}
	if diff := cmp.Diff(expectedLeast, gotLeast); diff != "" {
		t.Errorf("SimulateLeast() mismatch (-want +got):\n%s", diff)
	}
}
