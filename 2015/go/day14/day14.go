package day14

import "fmt"

type Reindeer struct {
	name string
	rate int
	t1   int
	t2   int
}

func Parse(line string) Reindeer {
	var name string
	var rate, t1, t2 int
	fmt.Sscanf(line, "%s can fly %d km/s for %d seconds, but then must rest for %d seconds.", &name, &rate, &t1, &t2)
	return Reindeer{name, rate, t1, t2}
}

func Race(input []string, time int) int {
	max := 0
	for _, line := range input {
		reindeer := Parse(line)
		d := Distance(reindeer, time)
		if d > max {
			max = d
		}
	}
	return max
}
func Points(input []string, time int) int {
	scores := make([]int, len(input))
	reindeer := make([]Reindeer, len(input))
	for idx, line := range input {
		reindeer[idx] = Parse(line)
	}
	for i := 1; i <= time; i++ {
		currentDistances := make([]int, len(reindeer))
		for ri := 0; ri < len(reindeer); ri++ {
			currentDistances[ri] = Distance(reindeer[ri], i)
		}
		_, maxD, _ := MinMax(currentDistances)

		for idx, distance := range currentDistances {
			if distance == maxD {
				scores[idx] += 1
			}
		}
	}
	_, max, _ := MinMax(scores)
	return max
}
func MinMax(vals []int) (int, int, bool) {
	if len(vals) == 0 {
		return 0, 0, false
	}
	min := vals[0]
	max := vals[0]
	for _, v := range vals {
		if min > v {
			min = v
		}
		if max < v {
			max = v
		}
	}
	return min, max, true
}

func Distance(reindeer Reindeer, time int) int {
	period := reindeer.t1 + reindeer.t2
	fullPeriods := time / period
	partialPeriod := time % period
	minVal, _, _ := MinMax([]int{partialPeriod, reindeer.t1})
	return (fullPeriods*reindeer.t1 + minVal) * reindeer.rate
}
