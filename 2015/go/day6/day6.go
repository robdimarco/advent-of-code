package day6

import (
	"fmt"
	"strings"
)

type Instruction struct {
	Cmd      string
	StartPos [2]int
	EndPos   [2]int
}

func GetInstructions(input []string) []Instruction {
	rv := make([]Instruction, len(input))
	for idx, str := range input {
		rv[idx] = GetInstruction(str)
	}
	return rv
}

func GetInstruction(input string) Instruction {
	var cmd string
	var row1, row2, col1, col2 int
	if strings.HasPrefix(input, "turn") {
		fmt.Sscanf(input, "turn %s %d,%d through %d,%d", &cmd, &row1, &col1, &row2, &col2)
	} else {
		fmt.Sscanf(input, "%s %d,%d through %d,%d", &cmd, &row1, &col1, &row2, &col2)
	}
	return Instruction{Cmd: cmd, StartPos: [2]int{row1, col1}, EndPos: [2]int{row2, col2}}
}

func Part1(input []string) int {
	grid := make([][]int, 1000)
	for i := 0; i < 1000; i++ {
		grid[i] = make([]int, 1000)
	}
	for _, instruction := range GetInstructions(input) {
		for row := instruction.StartPos[0]; row <= instruction.EndPos[0]; row++ {
			for col := instruction.StartPos[1]; col <= instruction.EndPos[1]; col++ {
				switch instruction.Cmd {
				case "on":
					grid[row][col] = 1
				case "off":
					grid[row][col] = 0
				case "toggle":
					grid[row][col] = (grid[row][col] * -1) + 1
				}
			}
		}
	}
	sum := 0
	for _, row := range grid {
		for _, val := range row {
			sum += val
		}
	}
	return sum
}

func Part2(input []string) int {
	grid := make([][]int, 1000)
	for i := 0; i < 1000; i++ {
		grid[i] = make([]int, 1000)
	}
	for _, instruction := range GetInstructions(input) {
		for row := instruction.StartPos[0]; row <= instruction.EndPos[0]; row++ {
			for col := instruction.StartPos[1]; col <= instruction.EndPos[1]; col++ {
				switch instruction.Cmd {
				case "on":
					grid[row][col] += 1
				case "off":
					if grid[row][col] > 0 {
						grid[row][col] -= 1
					}
				case "toggle":
					grid[row][col] += 2
				}
			}
		}
	}
	sum := 0
	for _, row := range grid {
		for _, val := range row {
			sum += val
		}
	}
	return sum
}
