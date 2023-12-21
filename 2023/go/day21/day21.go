package day21

import (
	"fmt"
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

func IsValid(pos Pos, data [][]string, extended bool) bool {
	r := pos.r
	c := pos.c
	if extended {
		for {
			if r >= 0 {
				break
			}
			r += len(data)
		}
		for {
			if c >= 0 {
				break
			}
			c += len(data)
		}
		r = r % len(data)
		c = c % len(data[r])
		return data[r][c] != "#"
	}
	return r > -1 && c > -1 && r < len(data) && c < len(data[r]) && data[r][c] != "#"
}

func StartPos(data [][]string) Pos {
	i := 0
	for {
		r := i / len(data)
		c := i % len(data)
		if data[r][c] == "S" {
			return Pos{r, c}
		}
		i += 1
	}
}

type Pos struct {
	r int
	c int
}

func Run(data string, steps int, extended bool) int {
	parsed := parse(data)
	positions := map[Pos]bool{}

	positions[StartPos(parsed)] = true
	i := 0
	for {
		if i == steps {
			return len(positions)
		}
		if i%100 == 0 {
			fmt.Print(".")
		}
		i += 1
		n := map[Pos]bool{}
		for pos := range positions {
			r := pos.r
			c := pos.c
			for _, dim := range [][]int{{0, 1}, {1, 0}, {0, -1}, {-1, 0}} {
				dr := dim[0]
				dc := dim[1]
				nr := r + dr
				nc := c + dc
				if IsValid(Pos{nr, nc}, parsed, extended) {
					pos2 := Pos{nr, nc}
					if _, ok := n[pos2]; !ok {
						n[pos2] = true
					}
				}
			}
			positions = n
		}
		// fmt.Printf("pos: %v\n\n", positions)
	}
}

// https://mathworld.wolfram.com/LagrangeInterpolatingPolynomial.html
//
// P(x) = ((x-x_2)(x-x_3))/((x_1-x_2)(x_1-x_3))y_1+((x-x_1)(x-x_3))/((x_2-x_1)(x_2-x_3))y_2+((x-x_1)(x-x_2))/((x_3-x_1)(x_3-x_2))y_3
// for x = [0, 1, 2], y = [y1, y2, y3]
// f(x)
//
//	 = (x-1)(x-2) * y1 /2  - (x)*(x-2) * y2 + x(x-1)*y3/2
//		= (x^2 - 3x + 2) * y1 /2 - (x^2 - 2x) * y2 + (x^2-x)* y3/2
//		= ax^2 + bx + c
//		  where a = (y1 / 2 - y2 + y3/2), b = -3 * y1 /2 + 2 (y2) - y3/2, c = y1
func simplifiedLagrange(y1, y2, y3 int) []int {
	return []int{
		y1/2 - y2 + y3/2,
		-3*(y1/2) + 2*y2 - y3/2,
		y1,
	}
}

func Part1(data string, steps int) int {
	return Run(data, steps, false)
}

func Part2(data string) int {
	// Grid is 131 lines long with S at 65,65.
	// Data repeats in a quadratic fashion for each full run through the grid
	//  e.g. point 65 == 0th point as we moved up and out of the grid, point 65+131 = point 2, etc.
	// So first 3 points we want to measure are N=65 (out of grid 1), N=65+131 (out of grid 2), N=65+2*131 (out of grid 3)

	coef := simplifiedLagrange(Run(data, 65, true), Run(data, 65+131, true), Run(data, 65+131+131, true))
	// coef = simplifiedLagrange(3762, 33547, 93052)

	steps := 26_501_365
	target := (steps - 65) / 131 // Nice round number!, Gets us out and then repeats
	return target*target*coef[0] + target*coef[1] + coef[2]

}
