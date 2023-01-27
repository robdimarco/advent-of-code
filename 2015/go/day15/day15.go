package day15

import (
	"fmt"
	"strings"
)

type Ingredient struct {
	Name                                            string
	Capacity, Durability, Flavor, Texture, Calories int
}

func ParseLine(line string) Ingredient {
	var name string
	var capacity, durability, flavor, texture, calories int
	fmt.Sscanf(line, "%s capacity %d, durability %d, flavor %d, texture %d, calories %d",
		&name, &capacity, &durability, &flavor, &texture, &calories)

	return Ingredient{strings.TrimSuffix(name, ":"), capacity, durability, flavor, texture, calories}
}

func Amounts(buckets int, total int) [][]int {
	if buckets == 1 {
		return [][]int{{total}}
	}
	rv := make([][]int, 0)
	for n := 0; n <= total; n++ {
		for _, old := range Amounts(buckets-1, total-n) {
			rv = append(rv, append(old, n))
		}
	}
	return rv
}
func Score(amounts []int, ingredients []Ingredient, requiredCalories int) int {
	type Added struct {
		amt        int
		ingredient Ingredient
	}
	ingredientsAdded := make([]Added, len(amounts))
	for idx, amt := range amounts {
		ingredientsAdded[idx] = Added{amt, ingredients[idx]}
	}
	if requiredCalories > 0 {
		sum := 0
		for _, added := range ingredientsAdded {
			sum += added.amt * added.ingredient.Calories
		}
		if sum != requiredCalories {
			return 0
		}
	}
	values := make([]int, 4)
	for _, added := range ingredientsAdded {
		values[0] += added.amt * added.ingredient.Capacity
		values[1] += added.amt * added.ingredient.Durability
		values[2] += added.amt * added.ingredient.Flavor
		values[3] += added.amt * added.ingredient.Texture
	}
	sum := 1
	for _, v := range values {
		if v <= 0 {
			return 0
		}
		sum *= v
	}
	return sum
}

func HighestScore(input []string, requiredCalories int) int {
	ingredients := make([]Ingredient, len(input))
	for idx, line := range input {
		ingredients[idx] = ParseLine(line)
	}
	amts := Amounts(len(ingredients), 100)
	max := -1
	for _, amt := range amts {
		s := Score(amt, ingredients, requiredCalories)
		if s > max {
			max = s
		}
	}
	return max
}
