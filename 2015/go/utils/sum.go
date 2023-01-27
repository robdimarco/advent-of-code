package utils

func Sum(vals []int) int {
	sum := 0
	for _, v := range vals {
		sum += v
	}

	return sum
}
