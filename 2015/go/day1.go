// data = File.read('day1.txt')
// floor = 0
// data.chars.each_with_index do |c, i| 
// 	if c == '('; 
// 		floor +=1; 
// 	elsif c == ')'; 
// 		floor -= 1; 
// 	end
//   if floor == -1; puts i+1; end
// end
// puts floor
package main  
 	
import (
	"fmt"
	"os"
)

func check(e error) {
	if e != nil {
			panic(e)
	}
}
 
func main() {  
	dat, err := os.ReadFile("../ruby/day1.txt")
	check(err)
	
	var floor = 0
	var in_basement = false
	for i := 0; i < len(dat); i++ {
		var c = dat[i]
		if c == '(' { 
			floor = floor + 1; 
		} else if c == ')' {
			floor = floor - 1; 
		}
		if !in_basement && floor == -1 {
			in_basement = true
			fmt.Printf("Basement: %d\n", i+1)
		}
		// fmt.Printf("%x ", s[i])
	}
  fmt.Println(floor)  
}