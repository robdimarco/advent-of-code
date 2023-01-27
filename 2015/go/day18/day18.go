package day18

import "reflect"

func Parse(input []string) [][]int {
	rv := make([][]int, 0)
	for _, line := range input {
		v := make([]int, 0)
		for _, c := range []byte(line) {
			if c == '.' {
				v = append(v, 0)
			} else {
				v = append(v, 1)
			}
		}

		rv = append(rv, v)
	}
	return rv
}

func LitNeighbors(start [][]int, x int, y int) int {
	cnt := 0
	for _, nx := range []int{x - 1, x, x + 1} {
		if nx < 0 || nx >= len(start) {
			continue
		}
		for _, ny := range []int{y - 1, y, y + 1} {
			if ny < 0 || ny >= len(start[nx]) {
				continue
			}
			if nx == x && ny == y {
				continue
			}
			cnt += start[nx][ny]
		}
	}
	return cnt
}

func Evaluate(start [][]int, cornersOn bool) [][]int {
	rv := make([][]int, 0)
	for x, row := range start {
		rv = append(rv, make([]int, 0))
		for y, oldVal := range row {
			cnt := LitNeighbors(start, x, y)
			var newVal int
			if oldVal == 1 {
				if cnt == 2 || cnt == 3 {
					newVal = 1
				} else {
					newVal = 0
				}
			} else {
				if cnt == 3 {
					newVal = 1
				} else {
					newVal = 0
				}
			}
			if cornersOn {
				corners := [][]int{
					{0, 0},
					{0, len(row) - 1},
					{len(start) - 1, 0},
					{len(start) - 1, len(row) - 1},
				}
				if Contains(corners, []int{x, y}) {
					newVal = 1
				}
			}
			rv[len(rv)-1] = append(rv[len(rv)-1], newVal)
		}
	}
	return rv
}

func Contains(s [][]int, e []int) bool {
	for _, a := range s {
		if reflect.DeepEqual(a, e) {
			return true
		}
	}
	return false
}

func Iterate(input []string, steps int, cornersOn bool) [][]int {
	lights := Parse(input)
	for i := 0; i < steps; i++ {
		lights = Evaluate(lights, cornersOn)
	}
	return lights
}

func FlatSum(data [][]int) int {
	rv := 0
	for _, r := range data {
		for _, v := range r {
			rv += v
		}
	}
	return rv
}
