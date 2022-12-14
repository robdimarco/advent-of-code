package day1

import (
	"testing"
)

func TestFloor(t *testing.T) {
	var floor = floor("(")
	if floor != 1 {
		t.Errorf("Input: %v:\tExpected: %v\tActual:%v\n", '(', 4, floor)
	}
}

func TestBasement(t *testing.T) {

}

func TestPart1(t *testing.T) {

}

func TestPart2(t *testing.T) {

}

// func main() {
// 	dat, err := os.ReadFile("../ruby/day1.txt")
// 	check(err)

// 	var floor = 0
// 	// var in_basement = false
// 	for i := 0; i < len(dat); i++ {
// 		var c = dat[i]
// 		if c == '(' {
// 			floor = floor + 1
// 		} else if c == ')' {
// 			floor = floor - 1
// 		}
// 		// fmt.Printf("%x ", s[i])
// 	}
// 	fmt.Println(floor)
// }
