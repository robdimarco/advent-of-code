package day19

import (
	"fmt"
	"sort"
	"strings"
)

type Pair struct{ A, B string }

func Parse(input []string) (string, []Pair) {
	molecule := input[len(input)-1]
	pairs := make([]Pair, len(input)-2)
	for i := 0; i < len(input)-2; i++ {
		var a, b string
		fmt.Sscanf(input[i], "%s => %s", &a, &b)
		pairs[i] = Pair{a, b}
	}
	return molecule, pairs
}

func PossibleFromMolecule(molecule string, rules []Pair) []string {
	possibles := make([]string, 0)
	atoms := make([]string, 0)
	for i := 0; i < len(molecule); i++ {
		c := molecule[i]
		if c >= 'a' && c <= 'z' {
			lastOne := []byte(atoms[len(atoms)-1])
			nextVal := append(lastOne[:1], c)
			atoms = append(atoms[:len(atoms)-1], string(nextVal))
		} else {
			atoms = append(atoms, string([]byte{c}))
		}
	}

	for idx, atom := range atoms {
		for _, rule := range rules {
			src := rule.A
			result := rule.B
			if atom == src {
				newMolecule := strings.Join(
					[]string{
						strings.Join(atoms[0:idx], ""),
						result,
						strings.Join(atoms[idx+1:], ""),
					},
					"",
				)

				possibles = append(possibles, newMolecule)
			}
		}
	}
	return possibles
}

func Uniq(list []string) []string {
	cache := make(map[string]bool)
	rv := make([]string, 0)
	for _, v := range list {
		_, ok := cache[v]
		if !ok {
			cache[v] = true
			rv = append(rv, v)
		}
	}
	return rv
}
func DistinctCount(input []string) int {
	molecule, rules := Parse(input)
	return len(Uniq(PossibleFromMolecule(molecule, rules)))
}

type byLongestOutput []Pair

func (s byLongestOutput) Len() int {
	return len(s)
}

func (s byLongestOutput) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s byLongestOutput) Less(i, j int) bool {
	return len(s[i].B) > len(s[j].B)
}

func Generate(input []string) int {
	molecule, rules := Parse(input)
	sort.Sort(byLongestOutput(rules))
	count := 0
	for {
		if molecule == "e" {
			break
		}
		for _, rule := range rules {
			idx := strings.Index(molecule, rule.B)
			if idx >= 0 {
				molecule = molecule[0:idx] + rule.A + molecule[idx+len(rule.B):]
				count += 1
				break
			}
		}
	}
	return count
}
