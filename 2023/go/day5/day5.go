package day5
import (
    "strings"
"strconv"
"regexp"
"fmt"
)
// File.open("day5.txt").read.lines.map(&:strip)


// def parse(lines)
//   seeds = lines[0].split(' ').map(&:to_i)
//   seeds.shift
//   transforms = []
//   i = 1
//   loop do
//     break if i >= lines.size
//     l = lines[i]
//     i+=1
//     next if l.empty?


//     if l =~ /^\d+/
//       transforms[-1].push(l.split(' ').map(&:to_i))
//     else
//       transforms.push([])
//     end
//   end
//   [seeds, transforms]
// end

func split(data string) []string {
    rv := []string{}
    for _, line := range strings.Split(strings.TrimSuffix(data, "\n"), "\n") {
        rv = append(rv, line)
    }
    return rv
}

func parse(data string) ([]int, [][][]int){
    lines := split(data)
    seeds := []int{}
    for i, s := range strings.Split(lines[0], " ") {
        if i > 0 {
            i, _ := strconv.Atoi(s)
            seeds = append(seeds, i)
        }
    }

    transforms := [][][]int{}
    for idx, l := range lines{
        if idx == 0 || l == "" {
            continue
        }

        if match, _ := regexp.MatchString("^[0-9]", l); match {
            vals := []int{}
            for _, s := range strings.Split(l, " ") {
                v, _ :=  strconv.Atoi(s)
                vals = append(vals, v)
            }

            transforms[len(transforms) - 1 ] = append(transforms[len(transforms) - 1], vals)
        } else {
            transforms = append(transforms, [][]int{})
        }

    }
    return seeds, transforms
}

func Part1(data string) int {
    seeds, transforms := parse(data)
    min := -1
    for _, seed := range seeds {
        acc := seed
        for _, transform := range transforms {
            for _, t := range transform {
                dest := t[0]
                start := t[1]
                rng := t[2]
                if start <= acc && acc < start + rng {
                  acc = acc - start + dest  
                  break
                }
            }
        }
        if min < 0 || min > acc {
            min = acc
        }
    }
    return min
}

func Part2(data string) int {
    seed_ranges, transforms := parse(data)
    seeds := []int{}
    i := 0
    for {
        if i == len(seed_ranges) {
            break
        }
        a := seed_ranges[i]
        b := seed_ranges[i+1]
        q := 0
        i +=2
        for {
            if q == b {
                break
            }

            seeds = append(seeds, a + q)
            q += 1
        }

    }
    fmt.Printf("Trying out %d seeds", len(seeds))

    min := -1
    for _, seed := range seeds {
        acc := seed
        for _, transform := range transforms {
            for _, t := range transform {
                dest := t[0]
                start := t[1]
                rng := t[2]
                if start <= acc && acc < start + rng {
                  acc = acc - start + dest  
                  break
                }
            }
        }
        if min < 0 || min > acc {
            min = acc
        }
    }
    return min
}

// def part2(data)
//   seed_ranges, transforms = parse(data)
//   seeds = []
//   loop do
//     break if seed_ranges.empty?
//     print "."
//     s = seed_ranges.shift
//     r = seed_ranges.shift
//     seeds += (s..(s+r)).to_a
//   end
