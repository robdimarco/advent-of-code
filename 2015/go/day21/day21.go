package day21

import (
	"fmt"
	"math/rand"
)

type Player struct {
	Name                     string
	Hp, Damage, Armor, Spend int
}
type Item struct {
	Name                string
	Cost, Damage, Armor int
}

func Parse(input []string) []Item {
	rv := make([]Item, len(input))
	for idx, line := range input {
		var name string
		var cost, damage, armor int
		fmt.Sscanf(line, "%s %d %d %d", &name, &cost, &damage, &armor)
		rv[idx] = Item{name, cost, damage, armor}
	}
	return rv
}

var WEAPONS = Parse([]string{
	"Dagger        8     4       0",
	"Shortsword   10     5       0",
	"Warhammer    25     6       0",
	"Longsword    40     7       0",
	"Greataxe     74     8       0",
})

var ARMOR = append(
	Parse([]string{
		"Leather      13     0       1",
		"Chainmail    31     0       2",
		"Splintmail   53     0       3",
		"Bandedmail   75     0       4",
		"Platemail   102     0       5",
	}), Item{"null", 0, 0, 0})

var RINGS = Parse([]string{
	"Damage+1    25     1       0",
	"Damage+2    50     2       0",
	"Damage+3   100     3       0",
	"Defense+1   20     0       1",
	"Defense+2   40     0       2",
	"Defense+3   80     0       3",
})

func GearUp(hp int) Player {
	weapon := WEAPONS[rand.Intn(len(WEAPONS))]
	armorAdd := ARMOR[rand.Intn(len(ARMOR))]
	rings := make([]Item, len(RINGS))
	copy(rings, RINGS)
	rand.Shuffle(len(rings), func(i, j int) {
		rings[i], rings[j] = rings[j], rings[i]
	})
	ringsToUse := make([]Item, rand.Intn(3))
	for i := range ringsToUse {
		ringsToUse[i] = rings[i]
	}
	items := append(append(ringsToUse, weapon), armorAdd)
	var damage, armor, spend int
	for _, item := range items {
		damage += item.Damage
		armor += item.Armor
		spend += item.Cost
	}
	return Player{"player", hp, damage, armor, spend}
}

func Battle(a Player, b Player) Player {
	damage := a.Damage - b.Armor
	if damage < 1 {
		damage = 1
	}
	b.Hp -= damage

	if b.Hp <= 0 {
		return a
	} else {
		return Battle(b, a)
	}
}

func Simulate(times int) (int, int) {
	winners := make([]Player, 0)
	losers := make([]Player, 0)
	for i := 0; i < times; i++ {
		player := GearUp(100)
		boss := Player{"boss", 100, 8, 2, 0}
		winner := Battle(player, boss)
		if winner.Name == "player" {
			winners = append(winners, winner)
		} else {
			losers = append(losers, player)
		}
	}
	mostEfficient := winners[0].Spend
	for _, w := range winners {
		if mostEfficient > w.Spend {
			mostEfficient = w.Spend
		}
	}
	leastEfficient := losers[0].Spend
	for _, l := range losers {
		if leastEfficient < l.Spend {
			leastEfficient = l.Spend
		}
	}

	return mostEfficient, leastEfficient
}
