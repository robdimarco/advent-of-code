package utils

func UniqInt(list []int) []int {
	cache := make(map[int]bool)
	rv := make([]int, 0)
	for _, v := range list {
		_, ok := cache[v]
		if !ok {
			cache[v] = true
			rv = append(rv, v)
		}
	}
	return rv
}
