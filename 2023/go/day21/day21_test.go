package day21

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestDay21(t *testing.T) {
	const sample = `	...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........`

	var real, _ = os.ReadFile("../../ruby/day21.txt")

	t.Run("Part1", func(t *testing.T) {
		t.Run("sample", func(t *testing.T) { assert.Equal(t, 16, Part1(sample, 6)) })
		t.Run("real", func(t *testing.T) { assert.Equal(t, 3697, Part1(string(real), 64)) })
	})
	t.Run("Part2", func(t *testing.T) {
		t.Run("sample real", func(t *testing.T) {
			assert.Equal(t, 608152828731262, Part2(string(real)))
		})
	})
}
