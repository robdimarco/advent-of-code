package day5

import (
	"testing"
	"os"
	"github.com/stretchr/testify/assert"
)

func TestDay5(t *testing.T) {
	const sample = `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`

var real, _ = os.ReadFile("../../ruby/day5.txt") 

	t.Run("part1 - sample", func(t *testing.T) {	assert.Equal(t, 35, Part1(sample)) })
	t.Run("part1 - real", func(t *testing.T) {	assert.Equal(t, 265018614, Part1(string(real))) })
	t.Run("part2 - sample", func(t *testing.T) {	assert.Equal(t, 46, Part2(sample)) })
	t.Run("part2 - real", func(t *testing.T) {	assert.Equal(t, 63179500, Part2(string(real))) })
}
