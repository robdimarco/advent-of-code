package day3

import "github.com/emirpasic/gods/sets/hashset"

type Params struct {
	input string
	elves int
}

func DeliveryCount(params Params) int {
	var elves int
	if params.elves > 0 {
		elves = params.elves
	} else {
		elves = 1
	}

	sets := make([]*hashset.Set, elves)
	pos := [2]int{0, 0}
	for i := range sets {
		sets[i] = hashset.New()
		sets[i].Add(pos)
	}

	for i, c := range params.input {
		dx := 0
		dy := 0
		switch c {
		case '^':
			dy = -1
		case 'v':
			dy = 1
		case '<':
			dx = -1
		case '>':
			dx = 1
		}
		new_pos := [2]int{pos[0] + dx, pos[1] + dy}
		sets[(i+1)%elves].Add(new_pos)
		pos = new_pos
	}
	sum := 0
	for _, set := range sets {
		sum += set.Size()
	}
	return sum
}
