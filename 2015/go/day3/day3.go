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
	positions := make(map[int][2]int)
	for i := range sets {
		positions[i] = [2]int{0, 0}
		sets[i] = hashset.New()
		sets[i].Add(positions[i])
	}

	for i, c := range params.input {
		idx := (i + 1) % elves
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
		new_pos := [2]int{positions[idx][0] + dx, positions[idx][1] + dy}
		sets[idx].Add(new_pos)
		positions[idx] = new_pos
	}
	all := hashset.New()
	for _, set := range sets {
		all = all.Union(set)
	}
	return all.Size()
}
