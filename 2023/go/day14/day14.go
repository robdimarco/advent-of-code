package day14

import (
	"strings"
)

func split(data string) []string {
	rv := []string{}
	s := strings.Split(strings.TrimSuffix(data, "\n"), "\n")
	for _, ss := range s {
		if len(ss) > 0 {
			rv = append(rv, ss)
		}
	}
	return rv
}
func parse(data string) [][]string {
	lines := split(data)
	rv := [][]string{}
	for i, line := range lines {
		if strings.TrimSpace(line) != "" {
			rv = append(rv, []string{})
			rv[i] = append(rv[i], strings.Split(line, "")...)
		}
	}
	return rv
}

func load(data [][]string) int {
	rv := 0
	for idx, row := range data {
		for _, r := range row {
			if r == "O" {
				rv += len(data) - idx
			}
		}
	}
	return rv
}

func tiltNorth(data [][]string) [][]string {
	for i := range data {
		r := i
		for c := range data[r] {
			n := 0
			for {
				if n >= i {
					break
				}
				r1 := r - n
				r2 := r - n - 1
				if data[r1][c] == "O" && data[r2][c] == "." {
					data[r1][c] = "."
					data[r2][c] = "O"
				}
				n += 1
			}
		}
	}

	return data
}

func rotate(data [][]string) [][]string {
	rv := [][]string{}
	i := 0
	for {
		if i >= len(data[0]) {
			break
		}
		rv = append(rv, make([]string, len(data)))
		i += 1
	}

	for col, r := range data {
		// fmt.Printf("line: %s", strings.Join(r, ""))
		for row, c := range r {
			// fmt.Printf("row %d len_r %d col %d\n", row, len(r), col)
			rv[row][len(r)-col-1] = c
		}
	}

	return rv
}

func cycle(data [][]string) [][]string {
	data = tiltNorth(data)
	i := 0
	for {
		if i == 3 {
			break
		}
		data = tiltNorth(rotate(data))
		i += 1
	}
	return rotate(data)
}

func Part1(lines string) int {
	return load(tiltNorth(parse(lines)))
}

func Part2(lines string) int {
	data := parse(lines)
	cache := map[string]int{}
	i := 0
	target := 1_000_000_000

	for {
		key := ""
		for _, line := range data {
			for _, c := range line {
				key += c
			}
			key += "\n"
		}
		if idx, ok := cache[key]; ok {
			left := (target - i) % (i - cache[key])

			for k, v := range cache {
				if v == idx+left {
					return load(parse(k))
				}
			}
		}

		data = cycle(data)
		cache[key] = i
		i += 1
	}
}
