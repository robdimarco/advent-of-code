package day14

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLoad(t *testing.T) {
	data := parse(`OOOO.#.O..
	OO..#....#
	OO..O##..O
	O..#.OO...
	........#.
	..#....#.#
	..O..#.O.O
	..O.......
	#....###..
	#....#....`)
	assert.Equal(t, 136, load(data))
}
func TestDay14(t *testing.T) {
	const sample = `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....`

	var real, _ = os.ReadFile("../../ruby/day14.txt")

	t.Run("part1 - sample", func(t *testing.T) { assert.Equal(t, 136, Part1(sample)) })
	t.Run("part1 - real", func(t *testing.T) { assert.Equal(t, 112046, Part1(string(real))) })
	t.Run("part2 - sample", func(t *testing.T) { assert.Equal(t, 64, Part2(sample)) })
	t.Run("part2 - real", func(t *testing.T) { assert.Equal(t, 104619, Part2(string(real))) })
}
