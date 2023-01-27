package day12

import "encoding/json"

func SumJson(Data interface{}, SkipRed bool) int {
	switch t := Data.(type) {
	case []interface{}:
		return sumSlice(t, SkipRed)
	case map[string]interface{}:
		return sumMap(t, SkipRed)
	case float64:
		return int(t)
	default:
		return 0
	}
}

func sumMap(Val map[string]interface{}, SkipRed bool) int {
	rv := 0
	for _, v := range Val {
		if v == "red" && SkipRed {
			return 0
		}
		rv += SumJson(v, SkipRed)
	}
	return rv
}

func sumSlice(Val []interface{}, SkipRed bool) int {
	rv := 0
	for _, v := range Val {
		rv += SumJson(v, SkipRed)
	}
	return rv
}

func Sum(Input string, SkipRed bool) int {
	var f interface{}
	json.Unmarshal([]byte(Input), &f)
	return SumJson(f, SkipRed)
}
